package utils::uniquenames;

#
# $Id: uniquenames.pm,v 1.1 2001/12/17 23:54:14 pascal Exp $
#
# $Log: uniquenames.pm,v $
# Revision 1.1  2001/12/17 23:54:14  pascal
# This class is capable of generating names based on several criterion such as unicity, max length, prefix, case handling ...
#
#
# $Author: pascal $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#


# Generic algorithm for unique name generation
# Based on :
# 1) The input name
# 2) case handling : 0=no case conversion, 1=uppercase, 2=downcase
# 3) max len
# 4) Unicity control (using a hashtable which may be provided to the new routine)

# It can keep track of a whole set of unique names in a hash indexed on the filename and entry index

@ISA=();

sub new {
    my ($pkg, $casehandling, $maxlen, $prefix, $prefixsupport, $spacesubst, $procspecnode, $procentries, $optionalhash, ) = @_;
    my $obj = bless {
	casehandling  => $casehandling,
	maxlen        => $maxlen,
	prefix        => $prefix,
	prefixsupport => $prefixsupport,
	spacesubst    => $spacesubst,
	procspecnode  => $procspecnode,
	procentries   => $procentries,
	uniquevalues  => $optionalhash
      }, $pkg;

    return $obj;
}


sub mkUniqueName {
    my ($obj, $inputname, $entryprefix) = @_;
    my $casehandling = $obj->{casehandling};
    my $outputname = ($casehandling == 0 ? $inputname : ($casehandling == 1 ? uc $inputname : lc $inputname));

    # Prefix
    my $prefix;
    if ($obj->{prefixsupport}) {
	$prefix = $entryprefix || $obj->{prefix};
	$prefix = ($casehandling == 0 ? $prefix : ($casehandling == 1 ? uc $prefix : lc $prefix));    
    }

    # Size handling
    my $maxlen       = $obj->{maxlen} - (defined($prefix) ? length($prefix) : 0);

    # Space substitutions
    my $spacesubst   = $obj->{spacesubst};
    $outputname =~ s/\s+/$spacesubst/g;
    my $len = length($outputname);
    if ($len > $maxlen)  
    {
	if (defined($outputname =~ m/$spacesubt/)) 
	{
	    my @words  = split /$spacesubst/, $outputname;	
	    my $nwords = scalar @words;

	    my $cw = 0;
	    my $currword;
	    while ($len > $maxlen) 
	    {
		$currword = \$words[$cw]; my $wlen = length($currword);
		$currword = substr($currword, 0, $wlen-1);
		$cw = 0 if (++$cw == $nwords);
		$len--;
	    }
	    local $,= undef; 
	    $outputname = join(@words);
	}
	else
	{
	    # No sign of separator characters, so just truncate
	    $outputname = substr($outputname, 0, $maxlen);
	}
     }    
    return "${prefix}${outputname}";    
}

1;
