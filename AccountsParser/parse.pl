#!perl.exe -w

use strict;

sub process {
	my $r = shift;
	if (defined($r)) {
		my ($dt, $dtval, $amount, $desc)='';
		# detect date
		if ($r =~ m/^(\d+\. \d+)/) {
			$dt = $1;
			$r =~ s/${dt}//;
			$dt =~ s/\. //o;#remove space and point
		}

		# detect amount
		if ($r =~ m/([0-9]+\.?[0-9.]*,[0-9]+)/) {
			$amount = $1;
			$r =~ s/$amount//; # remove corresponding match
			$amount =~ s/\.//og;
		}
		
		# detect value date
		if ($r =~ m/\s+(\d+\.\d+)/o) { 
			$dtval = $1;
			$r =~ s/${dtval}//;
			$dtval =~ s/\.//og;
		}

		# do some cleanup in remaining string
		$r =~ s/\.//og;
		$r =~ s/\s+/ /og;				
		$r =~ s/^ //og;
		$r =~ s/ $//og;
		$desc = defined($r) ? $r : '';
		print ("${dt}|${desc}|${amount}|${dtval}\r\n");						
	} else { die "should not be here"; }
}

my $out=undef;
my $page = -1;
my $agence = "";
my $datesline = "";
my %vars;

my ($d1,$m1,$y1)='';
my ($d2,$m2,$y2)='';

my $line=<>;
while (defined($line)) {
    chomp($line);
    my $l = length($line);
    if ($line =~ m/RELEVE DE COMPTE/og) {
        if ($page < 0) {
            $datesline = <>;
            $datesline =~ s/^\s+//og;
            $datesline =~  s/(?:du|au) //og;
            my @fields = split(/\s+/, $datesline);
            ($d1,$m1,$y1,$d2,$m2,$y2) = @fields;

            $line=<>;
            $line =~ m/agence\s+:\s+(\w+)/og;
            $vars{'AGENCE'} = $1;
#            print("!!", @fields);
            #($d1,$m1,$y1,$d2,$m2,$y2) =~ m/du\s+(\d+)\s+(\w+)\s+(\d+)\s+au\s+(\d+)\s+(\w+)\s+(\d+)/og; # du 21 janvier 2016 au 21 février 2016
            #print ("$d1 $m1 $y1\n");
            #print ("$d2 $m2 $y2\n");
        }
        $page++;
    }
    if ($page < 0) {
#        if ($line=~ m/agence\s+\:\s+(\w+)/ogi) {
#            print("**");
#            $vars{'AGENCE'} = $1;
        }
        if ($line=~ m/(RIB|IBAN|BIC)\s+:\s+/og) {
            my $var = $1;
            $line =~  s/$var\s+:\s+//oge;
            $line = substr($line, 0, 55);
            $vars{$var}  = $line;
        }
    } else {
        if ($line =~ m/SOLDE\s+(DEBITEUR|CREDITEUR)/og) {

        }

#        print ("$line\n");
#        if ($line =~ m/^\d+(\. )\d+/) {
#            if (defined($out)) {
#                process($out);
#                $out=undef;
#            }
#            $out = ${line};
#        } else {
#            $out = "${out}${line}";
#        }
        $line=<>;
    }
}

#print($vars{'AGENCE'})
#print($vars{'IBAN'})
#print($vars{'BIC'})
#map { print  } each %vars; #"Agence: ${vars{'AGENCE'}}");

print ("$d1 $m1 $y1\n");
print ("$d2 $m2 $y2\n");
print ("${vars{'AGENCE'}}\n");