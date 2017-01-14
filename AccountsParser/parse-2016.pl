#!perl.exe -w

use strict;
use warnings FATAL => 'all';

# index ignore string (no regex for now)
my @ignore;
while (defined(my $data=<DATA>)) {
    chomp($data);
    push(@ignore, lc $data);
}
print(scalar @ignore, " ignore strings\r\n");

# concaténer et regrouper les lignes en fonction de la présente de la date d'opération ou de son absence
my @lines;
my $cat='';
my $cnt=0;
while (defined(my $line=<>)) {
    chomp($line);
    $line =~ s/^\s+//og;
    $line =~ s/\s+$//og;    
	#$line =~ s/\r//og;  
	$line =~ s/\// /og; 
    #$line =~ s/[;-!&_()\*\\]//og; # use tr//    
	$line =~ s/\s{2,}/ /og;
    next unless (defined($line)); # traiter si contenu significatif après nettoyage
    $cnt++;

	foreach my $k (@ignore) {
       my $idx = index(lc $line, $k);
       if ($idx>-1) { 
            #print ("ignore: $idx:$k\r\n");
            $line=undef; $cat=''; 
            last;
        }
    }
	
    next unless defined($line); # traiter seulement si ligne non ignorée

	# regroupement des lignes
	if ($line =~ m/^\d+\.\s*\d+/og) { # début d'une nouvelle transaction
		if (defined($cat)) {
			push(@lines, $cat);
			#print "new: ${cat}\r\n";
			#$cat=undef;
		}
		$cat = $line;
	} else {
		$cat = defined($cat) ? "${cat} $line" : $line;
	}
}
if (defined($cat)) {
	push(@lines, $cat);
}
print(scalar @lines . " lignes en entrée / ", $cnt, "\r\n\r\n");

#main part
my $yd = 2014; # année pour date d'opération
my $ym = $yd;  # année pour date de valeur
my @posit = qw(valtech recu paie rembourst); # mots clés pour inverser le signe vers positif (négatif par défaut)
my $pmd = undef; # mois précédent de l'opération
my $pmv = undef; # mois précédent de la date de valeur
$cnt = 0;

my $line='';
foreach my $line (@lines) {

    if ($line =~ m/(?<=\d{2}\.\d{2})(?:\s+)(\d*(?:\s|\.)?\d*,\d+)/og) {
        my $repl = " $1";
        my $matched = $&;
        $line =~ s/$matched/$repl/e; #og;
    }

    my @fields = split (/\s+/, $line);
    my $dtop = $fields[0];
    my $dtval = undef;
    shift @fields;

    my $idx = 0;
    my $amount = undef;
    foreach my $f (@fields) {

        if ($f =~ m/(\d+,\d+)/og && !defined($amount)) {
            # && !$f =~ m/\%/og) {
            $amount = $1;
            $amount =~ s/,/\./og;
            $fields[$idx] = undef;

            # calcul du signe: négatif par défaut
            # recherche de mots clés pour inversion vers positif
            my $sign = '-';
            my $llc = lc join(' ', (grep { defined($_) } @fields));
            my @found = grep { $llc =~ $_ } @posit;
            my $cnt = scalar (@found);
            $sign = '+' unless ($cnt == 0);
            $amount = "${sign}${amount}";

        } elsif ($f =~ m/(\d+\.\d+)/og) {
            $dtval = $1;
            $fields[$idx] = undef;
        }
        $idx++; # grep won't return the index

    }

    # traitement passage de l'année en se basant sur le mois précédent (date d'opération)
    my ($dtopd, $dtopm) = split (/\./, $dtop || '0.0');
    if (defined($pmd) && $pmd != $dtopm) {
        if ($pmd == 12 && $dtopm == 1) {
            $yd++;
        }
		$pmd = $dtopm;
		$dtop = "${dtopd}/${dtopm}/${yd}";
    }

    # traitement passage de l'année en se basant sur le mois précédent (date de valeur)
    if (defined($dtval)) {
        my ($dtvald, $dtvalm) = split (/\./, $dtval || '0.0');
        if (defined($pmv) && $pmv != $dtvalm) {
            if ($pmv == 12 && $dtvalm == 1) {
                $ym++;
            }
        }
        $pmv = $dtvalm;
        $dtval = "${dtvald}/${dtvalm}/${ym}";
    } else {
        print("E;dtval;$cnt;$line\r\n");
    }

    my $l = join(' ', (grep { defined($_) } @fields)); # reconstitution du libellé
    
	$dtval = '' unless defined($dtval);
	$dtop = '' unless defined($dtop);
	$amount ='' unless defined($amount);
	
    print ("G;${cnt};${dtop};${dtval};${amount};${l}\r\n");

    $cnt++;
}

#^\d{12,}
__DATA__
monnaie du compte
0 820 820 001
p. 1
p. 2
p. 3
p. 4
p. 5
p. 6
p. 7
total des montants releve de compte cheques
du\s+\d+\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d+\s+au\s+\d+\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d+
total des operations
solde debiteur au 
commissions sur services et opérations bancaires
montant de votre autorisation de débit en compte au 
taux nominal de
un taeg de 
le taeg effectif résultera de l'utilisation de débit en compte dans la limite du taux de 
sera communiqué lors de l'arrêté trimestriel
rappel : votre numéro client est le : 
il vous permet de gérer vos comptes et
effectuer vos opérations courantes auprès du centre de relations clients
0 820 820 001
et complété de votre code secret, sur
internet www.bnpparibas.net, ou sur votre mobile à l adresse
mobile.bnpparibas.net pour obtenir votre code secret,
contactez votre conseiller.
\* \* \* \* \*
vous avez des questions ? vous rencontrez un problème ? votre conseiller et le directeur de votre agence sont à votre écoute. si leur réponse ne vous
convient pas, vous pouvez écrire au service consommateurs. enfin, en dernier recours, vous pourrez saisir par courrier le médiateur de bnp paribas
à l'adresse suivante :
médiateur auprès de bnp paribas - clientèle des particuliers - aci : cihrcc1 - 75450 paris cedex 09.
le médiateur, qui est indépendant, vous apportera une réponse dans les deux mois de la saisine, sous réserve que votre demande soit
éligible à la médiation et que les recours précédents n'aient pas permis de trouver une solution.
602132587126
scpt080strebhc0104
78800 houilles
4 b rue de jemmapes
mr ou mme munerot
agence : houilles
tél. : 0 820 820 001 (service 0,12¤/mn + prix d'appel)
ou n° non surtaxé de votre conseiller
information prealable
en matiere de frais bancaires
rib : 30004 01313 00000591368 76
iban : fr76 3000 4013 1300 0005 9136 876
bic : bnpafrpplay
madame, monsieur,
conformément à l'article l312-1-5 du code monétaire et financier, vous trouverez ci-après l'ensemble des
frais liés aux irrégularités et incidents de paiement survenus sur votre compte de dépôt sur la période
indiquée ci-dessus.
ces frais seront perçus par le débit de votre compte, dont les coordonnées figurent ci-dessus, au
15ème jour suivant la date d'arrêté de compte, soit à compter du 
nous vous rappelons que vous pouvez consulter le guide des conditions et tarifs dans votre agence ou sur
notre site mabanque.bnpparibas (coût de fourniture d'accès à internet).
votre conseiller reste bien entendu à votre disposition pour vous apporter tous compléments d'information.
vous pouvez le contacter pour faire, si nécessaire, le point sur le fonctionnement de votre compte et définir,
le cas échéant, la solution la plus adaptée à votre besoin.
nature des opérations
date de l'opération
montant en euros
commissions d'intervention
montant total
bnp paribas sa au capital de 2 492 372 484 ¤ - siège social : 16 bd des italiens, 75009 paris - rcs paris n° 662 042 449 - id. ce fr76662042449 - orias n° 07 022 735
0 820 820 001 \(service 0,12
mabanque.bnpparibas - réclamations/contestations : conseiller en agence 
ligne directe
non surtaxé
scpt080strebhc0104
mr ou mmemunerot 
00178 01313
releve de compte cheques 
taeg de 
le taeg effectif résultera de l'utilisation de l'autorisation de
solde créditeur