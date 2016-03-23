#!/usr/bin/perl

sub fatal {
    print shift;
    exit(1);
}


my $fname = shift @ARGV;
my $outdir = "../../site/htdocs/$fname";
$outdir =~  s/\.lyx$//;

fatal("tohtml <filename.lyx> - A script to generate a web-site using latex2html\nThis program is under the GNU public license\n") 
unless defined($fname) && (-f $fname);

print "generating site for $fname in $outdir\n";
#`latex2html -output-dir $outdir -mkdir`

