#!perl.exe -w

use strict; 

my $yd = 2015; # année pour date d'opération
my $ym = 2015; # année pour date de valeur
my @posit = qw(valtech emis paie); # mots clés pour inverser le signe vers positif (négatif par défaut)
my $pmd = undef; # mois précédent de l'opération
my $pmv = undef; # mois précédent de la date de valeur

while (defined(my $line=<>)) {
	chomp($line);
	while ($line =~ m/\r/og) { $line =~ s/\r//og; }
	while ($line =~ m/\//og)  { $line =~ s/\// /og; }
	while ($line =~ m/[-|!&_()\*\\]/og) { $line =~ s/[-|!&_()\*\\]//og; } # use tr//
	while ($line =~ m/\s{2,}/og) { $line =~ s/\s{2,}/ /og; }

	# nettoyage
	$line =~ s/^ //og;
	$line =~ s/ $//og;
	
#                    dtop        l1     dtval        amount         l2
# zones              0000001     02     00000003     0000000004     05
#	if ($line =~ m/^(\d+.\d+)\s+(.+)\s+(\d+\.\d+)\s+(\d+(?:\s*\.?)\d*,\d+)\s*(.*)?/) {
	if ($line =~ m/^(\d+.\d+)\s+(.+)\s+(\d+\.\d+)\s*(.*)?(\d+(?:\s*|\.)?\d*,\d+)\s*(.*)?/) {
		my ($dtop,$l1,$dtval,$l2,$amount,$l3)=($1,$2,$3,$4,$5,$6);

		# traitement passage de l'année en se basant sur le mois précédent (date d'opération)
		my ($dtopd,$dtopm)   = split (/\./, $dtop);
		if (defined($pmd) && $pmd != $dtopm) {
			if ($pmd==12 && $dtopm==1) {
				$yd++;
			}
			$pmd = $dtopm;
		}		
		$dtop = "${dtopd}-${dtopm}-${yd}";
				
		# traitement passage de l'année en se basant sur le mois précédent (date de valeur)
		my ($dtvald,$dtvalm) = split (/\./, $dtval);
		if (defined($pmv) && $pmv != $dtvalm) {
			if ($pmv==12 && $dtvalm==1) {
				$ym++;
			}
			$pmv = $dtvalm;
		}
		$dtval = "${dtvald}-${dtvalm}-${ym}";
 		
		# nettoyage espaces et conversion point décimal
		$amount=~ s/\s+//og;
		$amount=~ s/\.//og;
		$amount=~ s/,/\./og;
		
		my $l = "${l1} ${l2}"; # reconstitution du libellé

		# calcul du signe: négatif par défaut
		# recherche de mots clés pour inversion vers positif
		my $sign=-1;
		my $llc = lc $l; 
		my @found = grep { $llc =~ $_ } @posit;
		$sign = 1 unless (scalar (@found)==0);

		my $m = $amount * $sign;

		print ("G|${dtop}|${dtval}|${m}|${l}\r\n");		
	} else {
		print ("E|$line\r\n"); # erreur d'extraction (expression régulière)
	}

}


