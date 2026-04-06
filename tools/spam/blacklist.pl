#!perl.exe

use strict;
use warnings;
#use File::BOM;

my %addr;
open(IN, "<:encoding(UTF-16le)", "blacklist.txt")|| die "error $!\n";

while (defined(my $line=<IN>)) {
	chomp($line);
	if ($line =~ m/==/og) {
		$line =~ s/==//og;
	} 
	else {
		$line =~ s/^[^@]+//og;
	}
	$addr{$line}=1;
}
close(IN);
open(OUT, ">:encoding(UTF-16le)", "blacklist_unique.txt");
print OUT chr(65279); # https://stackoverflow.com/questions/7418946/force-utf-8-byte-order-mark-in-perl-file-output#7419264
# print $fh chr(0xFEFF); would be clearer. – Keith Thompson Sep 14 '11 at 16:46
#use File::BOM (); open my $fh, '> :utf8 :via(File::BOM)',
# $fh pack("CCC",0xef,0xbb,0xbf); 

print OUT join("\n", sort keys %addr);
close(OUT);