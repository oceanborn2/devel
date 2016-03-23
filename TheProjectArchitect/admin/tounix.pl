#!/usr/bin/perl

use Getopt::Long;
use File::Find;
use strict;

my $recurse = 0;
my $rewrite = 0;
my $nodir   = "cvs";
my $verbose = 1;

my $init_path;

GetOptions("recurse!" => \$recurse, "rewrite!" => \$rewrite, "nodir:s" => \$nodir, "verbose!" => \$verbose);

sub convertfile {
    # penser à lire et à restaurer les permissions des fichiers réécrits
    my $modified = 0; my $f = $_; 
    my $reldir = $File::Find::dir;
    return if ($reldir eq '.'); 

    my $absdir = $init_path; 
    $reldir =~ s|^.||;  
    $absdir = "${absdir}${reldir}"; 
    my $fname = "$absdir/$f"; 
    return if (-d "$fname" || (defined($absdir) && $reldir =~  m/^$nodir$/));
    
    my $w=-w $fname; my $T=-T $fname;
    print "$fname : examining, " if ($verbose);
    if ($w && $T) {
      my $line = "";
      my $tmpfile = "/tmp/tounix.tmp";
      open(IN, "< $fname");
      my $out = "";
      while (defined($line=<IN>)) {
	if ($line=~ m/\xD/) {
	    $modified=1;
	    $line =~ s/\xD//;
	    $out .= "$line";
	} else { $out .= $line; }
	$line="";
      }
      close(IN);

      if ($modified) {
         open(OUT,"> $tmpfile");
	 print OUT $out;
         close(OUT);
	 print "renaming from $tmpfile to $fname\n" if ($verbose);
	 rename($tmpfile, $fname) or die "Impossible de renommer le fichier";
      } else { print "not modified => skipping\n" if ($verbose); }

    } else { print "not writable or binary => skipping\n" if ($verbose); }
}

$init_path = $ENV{'PWD'};

if ($recurse) {
  find(\&convertfile, shift @ARGV || ".");
}
else { while(<>) { print; } }















