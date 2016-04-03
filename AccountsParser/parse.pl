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

sub getline {
	my $line=<DATA>;
	if (defined($line)) {
		chomp($line);
	}
	$line;
}

my $out=undef;
my $line=getline;
while (defined($line)) {
	if ($line =~ m/^\d+(\. )\d+/) {
		if (defined($out)) {
			process($out);
			$out=undef;			
		}	
		$out = ${line};					
	} else {
		$out = "${out}${line}";
	}	 
	$line=getline; 
}

if (defined($out)) {
		process($out);
}


__DATA__
07. 12 VIRT RECU M. MUNEROT PASCAL 07.12 20.000,00
09. 12 TIRAGE DE CHEQUES EMISSION CHEQUE DE 09.12
BANQUE 5787115 18.338,50
04. 01 ECHEANCE PRET 01313 60553567 04.01 421,29
14. 01 VIRT RECU MME MUNEROT SANDRINE 14.01 24.000,00
04. 02 ECHEANCE PRET 01313 60553567 04.02 384,64
04. 02 ECHEANCE PRET 01313 60557641 04.02 422,29
04. 02 VIREMENT RECU TIERS M OU MME PASCAL 04.02
MUNEROT 177VIREMENT
1ECH. 04022011 ND 20110009213-4-S 1.000,00
07. 02 CHEQUE 1332361 07.02 12.350,00

