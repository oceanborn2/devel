#!perl.exe -w

use strict;
use warnings FATAL => 'all';

my $yd = 2015; # année pour date d'opération
my $ym = $yd;  # année pour date de valeur
my @posit = qw(valtech recu paie rembourst); # mots clés pour inverser le signe vers positif (négatif par défaut)
my $pmd = undef; # mois précédent de l'opération
my $pmv = undef; # mois précédent de la date de valeur
my $lineno = 1;

while (defined(my $line = <>)) {
    chomp($line);
    while ($line =~ m/\r/og) { $line =~ s/\r//og; }
    while ($line =~ m/\//og)  { $line =~ s/\// /og; }
    #while ($line =~ m/[;-!&_()\*\\]/og) { $line =~ s/[;-!&_()\*\\]//og; } # use tr//
    while ($line =~ m/\s{2,}/og) { $line =~ s/\s{2,}/ /og; }

    # nettoyage
    $line =~ s/^ //og;
    $line =~ s/ $//og;

    if ($line =~ m/(?<=\d{2}\.\d{2})(?:\s+)(\d*(?:\s|\.)?\d*,\d+)/og) {
        my $repl = " $1";
        my $matched = $&;
        $line =~ s/$matched/$repl/og;
        #print("matched:[${matched}] repl:[${repl}]\r\n");
        #print("new:${line}\r\n");
    }

    my @fields = split (/\s+/, $line);
    my $dtop = $fields[0];
    my $dtval = undef;
    #print(@fields); print("\r\n");
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
            #print ("${cnt} llc:${llc}\r\n");
            $sign = '+' unless ($cnt == 0);
            $amount = "${sign}${amount}";
        } elsif ($f =~ m/(\d+\.\d+)/og) {
            $dtval = $1;
            $fields[$idx] = undef;
        }
        $idx++; # grep won't return the index
    }

    # traitement passage de l'année en se basant sur le mois précédent (date d'opération)
    my ($dtopd, $dtopm) = split (/\./, $dtop);
    if (defined($pmd) && $pmd != $dtopm) {
        if ($pmd == 12 && $dtopm == 1) {
            $yd++;
        }
    }
    $pmd = $dtopm;
    $dtop = "${dtopd}/${dtopm}/${yd}";

    # traitement passage de l'année en se basant sur le mois précédent (date de valeur)
    if (defined($dtval)) {
        my ($dtvald, $dtvalm) = split (/\./, $dtval);
        if (defined($pmv) && $pmv != $dtvalm) {
            if ($pmv == 12 && $dtvalm == 1) {
                $ym++;
            }
        }
        $pmv = $dtvalm;
        $dtval = "${dtvald}/${dtvalm}/${ym}";
    } else {
        print("E;dtval;$lineno;$line");
    }
    my $l = join(' ', (grep { defined($_) } @fields)); # reconstitution du libellé
    
    print ("G;${lineno};${dtop};${dtval};${amount};${l}\r\n");

    $lineno++;
}


