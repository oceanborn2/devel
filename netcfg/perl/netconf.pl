#!perl.exe

#!/usr/bin/perl -w


use strict;

use Term::ReadLine;
use POSIX qw(:sys_wait_h);

my $term = Term::ReadLine->new("net configuration utility");
my $OUT = $term->OUT() || *STDOUT;
my $cmd;

while (defined ($cmd = $term->readline('netconf> ') )) {
    my @output = `$cmd`;
    my $exit_value  = $? >> 8;
    my $signal_num  = $? & 127;
    my $dumped_core = $? & 128;
    printf $OUT "Program terminated with status %d from signal %d%s\n",
           $exit_value, $signal_num, 
           $dumped_core ? " (core dumped)" : "";
    print @output;
    $term->addhistory($cmd);
}
