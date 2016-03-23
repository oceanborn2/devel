#
# $Id: GenHandler.pm,v 1.7 2001/12/17 23:55:15 pascal Exp $
#
# $Log: GenHandler.pm,v $
# Revision 1.7  2001/12/17 23:55:15  pascal
# Separated the getNamesSupport method in two flavours : One for all the names objects, one for accessing them by name
#
# Revision 1.6  2001/12/17 17:34:49  pascal
# Added new directory 'utils' to shelter utility classes
#
# Revision 1.5  2001/12/09 23:02:26  pascal
# Lots of improvements - SQL now works and java just got better
#
# Revision 1.4  2001/12/07 20:28:16  pascal
# Added perl header
#
# $Author: pascal $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#

package GenHandler;

use strict;
use Data::Dumper;

sub new {
    my ($pkg, $type, $handler, $ext, $datamodel, $comment, $namestrategy, $lang_support) = @_;

    my $obj = bless {
	type         => $type,          # handler type
	handler      => $handler,       # reference to the sub implementing the handler body
	ext	     => $ext,           # extension for the output file
	datamodel    => $datamodel,     # model type (aka the data structure)
	comment      => $comment,       # any comment associated to the handler
	namestrategy => $namestrategy,  # a reference to a sub in charge of computing the output file name
	lang_support => $lang_support,  # reference to a subclass of Lang::generic.pm
	names_support=> {},
	globals      => undef
    }, $pkg;

    return $obj;
}

sub getFullHandler { return shift; }

sub getType {
    my $obj = shift;
    return $obj->{type};
}

sub getHandler { 
    my $obj = shift;
    return $obj->{handler};
}

sub getExt { 
    my $obj = shift;
    return $obj->{ext};
}

sub getDataModel { 
    my $obj = shift;
    return $obj->{datamodel};
}

sub getComment { 
    my $obj = shift;
    return $obj->{comment};
}

# gets a name strategy (A reference to sub capable of returning the file name as a string)
sub getNameStrategy { 
    my $obj = shift;
    return $obj->{namestrategy};
}

# Gets a target language handler
sub getLanguageSupport {
    my $obj = shift;
    return $obj->{lang_support};
}

sub setLanguageSupport {
    my ($obj, $lang_support) = @_;
    $obj->{lang_support} = $lang_support;
    return $obj;
}

# Computed global values
sub getGlobals {
    my $obj = shift;
    return $obj->{globals};
}

sub setGlobals {
    my ($obj, $globals) = @_;
    $obj->{globals} = $globals;    
}

# Not computed global values (as given by the spec node attributes in the XML file)
sub setSpecNode {
    my ($obj, $specnode) = @_;
    $obj->{specnode} = $specnode;
}

sub getSpecNode {
    my $obj = shift;
    return $obj->{specnode};
}

# returns a naming model by its name
sub getNamesSupport {
    my $obj = shift;
    return $obj->{names_support};
}

sub getSpecificNameSupport {
    my ($obj, $namingmodel) = @_;
    return $obj->{names_support}->{$namingmodel};
}

sub setNamesSupport {
    my ($obj, $namingmodel, $instance) = @_;
    $obj->{names_support}{$namingmodel} = $instance; # a ref to a lang::uniquenames object
    return $obj;
}

1;



