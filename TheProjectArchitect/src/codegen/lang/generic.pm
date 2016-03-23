#
# $Id: generic.pm,v 1.5 2002/04/14 20:55:36 pascal Exp $
#
# $Log: generic.pm,v $
# Revision 1.5  2002/04/14 20:55:36  pascal
# Changed way of getting current path for use with ANT
#
# Revision 1.4  2001/12/17 23:47:56  pascal
# Added unique name handling
#
# Revision 1.3  2001/12/09 23:41:05  pascal
# *** empty log message ***
#
#
# $Author: pascal $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#

package lang::generic;

use utils::uniquenames;
use XML::DOM;
use Cwd;
use strict;

my @ISA=();

my %DATATYPES; # singleton for caching types definitions

#### MAIN METHODS ###########################

sub new {
    my $pkg = shift;
    my $obj =  bless {
	eqct	=> 0,		# Number of equivalences
	globals => undef,	# Global
	types   => \%DATATYPES	# This hash should not be modified (Shall we make it a copy instead of a reference ?)
    }, $pkg;
    return $obj;
}

# processNamesSupports - invokes name calculations
# $nodetype == 1 => spec node
# $nodetype == 2 => entry node
sub processNamesSupports {
    my ($obj, $names_support, $entry, $prefix, $nodetype) = @_;
    my ($key, $name_support);

    # Iterate over each name support objects and invoke them on the current entry
    while (($key, $name_support) = each %$names_support) {
	$entry->{uniq}->{$key} = $name_support->mkUniqueName($entry->{name}, $prefix)
	if (($nodetype == 1 && $name_support->{procspecnode} == 1) ||
	    ($nodetype == 2 && $name_support->{procentries} == 1));
    }    
}

# runSpec - entry point for the generation system
# remarks:
# 1) A prefix can be given at the spec level or entry level. Any prefix at the entry level will override the spec level prefix
# 2) The spec node is faked as an entry. This will help override values at the entry level
# 3) Names support and type resolution is called both the spec node and the entries
# 4) Hooks have been created both the preprocessing and postprocessing (postprocessing is still before the actual code generation)
sub runSpec {
    my ($obj, $handler_ref, $entries) = @_;
    my $names_support = $handler_ref->getNamesSupport;

    
    # 1ST PHASE : process spec node
    my $specnode = $handler_ref->getSpecNode; # recovers attributes from the spec node
    my $specprefix = $specnode->{prefix};
    my $uniqname = $obj->processNamesSupports ($names_support, $specnode, $specprefix, 1); # compute unique names 
											   # (for the spec, faked as an entry)    
    # 2ND PHASE : process the spec's entries
    $obj->preProcess($handler_ref, $entries);
    foreach my $entry (@$entries) {
	$obj->processNamesSupports ($names_support, $entry, $entry->{prefix} || $specprefix, 2); # compute unique names
	$obj->processEntry($handler_ref, $entry);	     # preprocess entry (anything the language object might be willing to do) 
    }
    $obj->postProcess($handler_ref, $entries);
}

#### ACCESSORS METHODS ######################

sub getGlobals {
    my $obj = shift;
    return $obj->{globals};
}

sub setGlobals {
    my ($obj, $globals) = @_;
    $obj->{globals} = $globals;
    return $obj;
}

#### UTILITY METHODS ########################

# make a key for a given type and equivalence, does not need an object instance
# 1st arg : basetype
# 2nd arg : equiv name
# 3rd arg : sub equiv name (optional)

sub mkTypeKey { 
    my $key = "\@$_[0]::$_[1]";
    $key .= "::$_[2]" if ($_[2]); 
    return $key;
}

# returns the number of registered equivalences
sub getEquivsCount { 
    my $obj = shift;
    return $obj->{eqct};
}

# returns the hash for the type given as parameter, optionnally merged with the 'common' equivalence
sub getTypeDef {

    # recovering parameter typename
    my ($obj, $basetype, $equiv, $subequiv) = (shift, uc shift, lc shift, shift);
    my %results = undef;

    # shall we merge with the common equivalence
    my $merge = (shift || 1) && !($equiv eq "common"); # Shall we merge ? (avoiding infinite recursion)
    if ($merge) {
	%results= %{$obj->getTypeDef ($basetype, 'common', 0)};
    } 

    my $tkey = mkTypeKey ($basetype, $equiv, $subequiv);
    my $thistype = $obj->{types}{$tkey};

#### !!!! this part (type merging has not been tested) !!!! ####

    if (defined(%results)) {
	foreach my $key (keys %$thistype) {
		$results{$key}= $thistype->{$key}; # copies values and overrides any previously defined value for the key 
	}
    }
    else { %results = %$thistype; } # No need to merge, then only copy the hash as new

    return \%results; # returns the results as a reference to the newly allocated hash
}

# reads datatypes specifications and indexes them
sub readTypeSpecs {

    my $eqct = "\[equivcount\]";
    my %types;

    my $parser = XML::DOM::Parser->new();
    my $doc = $parser->parsefile(cwd."/src/codegen/lang/typespecs.xml");

    # first reads list of equivalences
    my $equivcount = 0;
    foreach my $equiv ($doc->getElementsByTagName('equiv')) 
    {
  	 $equivcount++;	
	 my $equivname  = $equiv->getAttribute('name');  
	 $types{$eqct}=$equivname;
    }    
    $types{"equivcount"}=$equivcount;
   
    # and then indexes types by their equivalence names 
    foreach my $spec ($doc->getElementsByTagName('datatype')) 
    {
	 # Processed datatypes nodes
	 my $datatypename  = $spec->getAttribute('name');  
         foreach my $node ($spec->getElementsByTagName('node'))  # Iterating over each node definition (ie type definition)
	 {
	   my $subeq = $node->getAttribute('subeq') || '';
	   my $equivname = $node->getAttribute('equiv') or warn "No name for equivalence type";
	   my $eqkey = mkTypeKey($datatypename, $equivname, $subeq);
	   my $nodemap = $node->getAttributes;
	   my $count   = $nodemap->getLength;
	   my %attr;
	   $attr{'attr_count'}=$count;
	   if ($count> 0) 
	   { 
	     foreach my $i (0..$count-1)
             {
		my $attrnode     = $nodemap->item($i);
		my $attrname     = $attrnode->getName || "";
		my $attrvalue    = $attrnode->getValue || "";
		$attr{$attrname} = $attrvalue;
             }  
	   } 
	   $types{$eqkey}= \%attr;
	 }	 
    }    
    
    return %types;

}

sub getTypes { 
    my $obj = shift;
    return $obj->{types};
}
 
sub computeType { return undef; }

BEGIN {
    %DATATYPES = readTypeSpecs; # create types list as singleton
}

1;







