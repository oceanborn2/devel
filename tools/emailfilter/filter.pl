#!perl.exe

use warnings FATAL => 'all';
use strict;

my %uniq;
my $rowc=0;
my $irowc=0;
my $urowc=0;
my $uerr=0;

open(OUT,">email.csv");
while (defined(my $line=<DATA>)) {
	chomp($line);
	
	my $check=$line; # control number of semicolons
	$check=~ s/[^;]+//ogi;
	print "check(" . length($check) . ") $check\n\n";

	my @rows = split(/;/, $line);
	$rowc= scalar(@rows);

	foreach my $row (@rows)  {
		$irowc++;
#		print "row:$row\n";
#		$row=~ m/^\s*//og;
#		$row=~ m/\s*$//og;
		#$row=~  m/\s*([^,]+),\s*([^(]+)?\s+\(([^)]+)\)\s+<([^>]+)>/og;
		# $row=~ m/\s+\(([^)]+)\)\s+<?([^>]+)>?/og;

		my $ln="";
		my $fn="";
		if ($row=~ m/\s*([^,]+),\s+([^(]+)\s+/og) { # match lastname, firstname if any
			($ln, $fn) = ($1,$2);
			my $c = length($&);
			substr($row,0, $c) = ""; #$row=~ s/$&//og;
			# print "row:$row  fn:$fn  ln:$ln\n";
		}

		my $loc="";
		if ($row=~ m/\(([^)]+)\)/og) {
			$loc= $1;
			my $c=length($&);
			substr($row, 0, $c) = ""; #$row=~ s/$&//;
		}
		my $email= $row;
		$email =~ s/^\s+<?//og;
		$email =~ s/\s*>?$//og;

		my @fields = (ucfirst $ln, ucfirst $fn, lc $loc,lc $email);
		my $s =  join(';', @fields);
		if (exists $uniq{$s}) {
			print STDERR "duplicate: $s\n";
			$uerr++;
		} else {
			$uniq{$s}=1;
			$urowc++;
			print OUT "$s\n";			
		}
	}
}
close(OUT);

print "$rowc total rows (semicolon split)\n";
print "$irowc rows (in loop)\n";
print "$urowc unique rows\n";
print "$uerr duplicates\n";



__DATA__
Lastname, Firstname (location) <firstname.lastname@domain>
