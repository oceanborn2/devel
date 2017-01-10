#!perl.exe -w

use strict;

#sub process {
#	my $r = shift;
#	if (defined($r)) {
#		my ($dt, $dtval, $amount, $desc)='';
#		# detect date
#		if ($r =~ m/^(\d+\. \d+)/) {
#			$dt = $1;
#			$r =~ s/${dt}//;
#			$dt =~ s/\. //o;#remove space and point
#		}
#
#		# detect amount
#		if ($r =~ m/([0-9]+\.?[0-9.]*,[0-9]+)/) {
#			$amount = $1;
#			$r =~ s/$amount//; # remove corresponding match
#			$amount =~ s/\.//og;
#		}
#
#		# detect value date
#		if ($r =~ m/\s+(\d+\.\d+)/o) {
#			$dtval = $1;
#			$r =~ s/${dtval}//;
#			$dtval =~ s/\.//og;
#		}
#
#		# do some cleanup in remaining string
#		$r =~ s/\.//og;
#		$r =~ s/\s+/ /og;
#		$r =~ s/^ //og;
#		$r =~ s/ $//og;
#		$desc = defined($r) ? $r : '';
#		print ("${dt}|${desc}|${amount}|${dtval}\r\n");
#	} else { die "should not be here"; }
#}


sub monthStrToNum {
    my $s = shift;
    my @months=qw(janvier février mars avril mai juin juillet août septembre octobre novembre décembre);
    $s = lc $s;
    foreach my $idx (0..11) {
        if ($s eq $months[$idx]) {
            return 1+$idx;
        }
    }
    return '??';
}

sub isDate {
    my $ds = shift;
    return defined($ds =~  m/\d+\.\d+);
}

my $out=undef;
my $page = -1;
my $agence = "";
my $datesline = "";
my %vars;

my ($d1,$m1,$y1)='';
my ($d2,$m2,$y2)='';

my ($typsold, $solde, $sd, $sm, $sy)='';
my ($datepos, $descpos, $dvalpos, $debitpos, $creditpos)='';
my @rows;

my $line=<>;
while (defined($line)) {
    chomp($line);
    if ($line =~ m/RELEVE DE COMPTE/og) {
        if ($page < 0) {
            $datesline = <>;
            $datesline =~ s/^\s+//og;
            $datesline =~  s/(?:du|au) //og;
            my @fields = split(/\s+/, $datesline);
            ($d1,$m1,$y1,$d2,$m2,$y2) = @fields;
             $m1=monthStrToNum($m1);
             $m2=monthStrToNum($m2);

            $line=<>;
            while ($line !~ m/D\s+ate\s+N\s+ature/og) {
               if ($line=~ m/(AGENCE|RIB|IBAN|BIC)\s+:\s+/og) {
                    my $var = $1;
                    $line =~ s/(AGENCE|RIB|IBAN|BIC)\s+\:\s+//og;
                    $line = substr($line, 0, 55);
                    $line =~ s/^\s+//og;
                    $line =~ s/\s+$//og;
                    $vars{$var}  = $line;
               }
               $line=<>;
            }
            $datepos = index($line,"D ate");
            $descpos = index($line,"N ature des");
            $dvalpos = index($line,"V aleur");
            $debitpos = index($line,"D ebit");
            $creditpos = index($line,"C redit");

            $line=<>;
            if ($line =~ m/SOLDE\s+(DEBITEUR|CREDITEUR)\s+AU\s+(\d+)\.(\d+)\.(\d+)\s+(.*)/og) {
                ($typsold,$sd,$sm,$sy,$solde) = ($1,$2,$3,$4,$5);# @_  ?
                $solde =~ s/\s+//og;
             }

       } else {
            # matching another "RELEVE DE COMPTE" header other than the first one
            <>;<>;<>;<>;<>; # skip 5 lines
       }
       $page++;
    } else {
        if ($line=~ m/\s+\d+\.\d+/og) { # detect lines starting with a date
            #$line =~ s/\s{3,}/|/og; # replace all sequences of more than 3 spaces with a pipe
            my $rdate = substr($line, $datepos, 5);
            my $rdesc = substr($line, $descpos, 60);
            my $rdval = substr($line, $dvalpos, 5);
            my $rdeb  = substr($line, $debitpos, 8);
            my $rcred = substr($line, $creditpos, 8);

            my $check=1;
            $check = 0 unless isDate($rdate) && isDate($rdval);
            if ($check) {
               push(@rows, ($rdate,$rdval,$rdesc,$rdeb,$rcred));
            }

        } else {
            push(@rows, ('', '', $line, '',''); #print(">>> $rdate|$rdval|$rdesc|$rdeb|$rcred\n");
        }
    }
    $line=<>;
}

foreach my $row (@rows) {
    print($row, "\n");
#        #$line =~ s/^\s+//og;
# #       $line =~ s/\s+$//og;
# #       $line =~ s/\s+/ /og;
# #       next if ($line eq '');
#        my @f = split(/\s+/,$row);
#        my $cf = scalar @f;
#        #next if ($cf ==0 || $cf > 10);# filter out garbage
#        my $lastf = $row[$cf-1]
#
#        print(join('|', @f),"\n")
##        next if (length($line) > 70);
#
##        if ($line =~ m/^\s+(\d+\.\d+)\s+/og) {
##            my $row = $line;
##            $line=<>;
##            while ($line !~ m/)
##            print("$line\n")
##        }
#
#
#        #        if ($line =~ m/^\d+(\. )\d+/) {
#        #            if (defined($out)) {
#        #                process($out);
#        #                $out=undef;
#        #            }
#        #            $out = ${line};
#        #        } else {
#        #            $out = "${out}${line}";
#        #        }
}


print ("datepos   : ", $datepos);
print ("descpos   : ", $descpos);
print ("dvalpos   : ", $dvalpos);
print ("$debitpos : ", $debitpos);
print ("$creditpos: ", $creditpos);

print ("$d1/$m1/$y1\n");
print ("$d2/$m2/$y2\n");
print ("$sd/$sm/$sy $typsold $solde\n");
while ( my($k, $v) = each %vars)
{
    print("var: $k = $v\n");
}

