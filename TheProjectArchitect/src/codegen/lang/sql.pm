#
# $Id: sql.pm,v 1.5 2001/12/17 23:51:33 pascal Exp $
#
# $Log: sql.pm,v $
# Revision 1.5  2001/12/17 23:51:33  pascal
# Added unique name handling, changed datatype attribute name from 'type' to 'datatype'
#
# Revision 1.4  2001/12/14 22:25:34  pascal
# Removed Dumper output
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

package lang::sql;

use lang::generic;

@ISA=qw(lang::generic);


sub preProcess {
}

sub postProcess {
}

sub processEntry {
    my ($obj, $handler_ref, $entry) = @_;
    $obj->computeType($handler_ref, $entry, 'postgres'); # @TODO 'postgres' should not be hardcoded  
}


# compute the type given its xml type and size
sub computeType {

    my ($obj, $handler_ref, $entry, $dbms) = @_;

    my $datatype  = $entry->{datatype};        # input type (ie generic type)
    return unless defined ($datatype);

    my $typedef     = $obj->SUPER::getTypeDef($datatype,'sql', $dbms); 

    my $bytesize    = $typedef->{bytesize}; # Not correct. Size should be a multiple of the type byte size. Add a new size attribute
    my $defaultsize = $typedef->{defaultsize}; # Not correct. Size should be a multiple of the type byte size. Add a new size attribute

    # @TODO Check that it is correct to do it that way
    my $size  = $entry->{size} || $defaultsize || $bytesize;   # input size. Optionnally overloaded by the defaultsize or bytesize

    # Is it really necessary to store these attributes in a specific hash ?
    my $class   = 
	{
	   inputtype   => $type,
           bytesize    => $typedef->{bytesize},
	   defaultsize => $typedef->{defaultsize},
	   defaultprec => $typedef->{defaultprec},
	   size        => $size 
	};
 
    # extdatatype can be used to overload the computed datatype
    my $sqltype =  $entry->{extdatatype} || $typedef->{datatype} || "*** UNKNOWN TYPE ***"; # Any user specified datatype is prioritary
    my $prec = $entry->{precision} || $typedef->{defaultprec};
#    my $comptype = $obj->computeType($handler_ref, $entry, $dbms); # TODO work out the concept of composite type

    my $disable_null = $typedef->{disable_nulls};
    
    my $nullable = $entry->{nullable} || 'no';
    
    $sqltype =~ s/%SZ/$size/g; # takes size field into account if any
    $sqltype =~ s/%PR/$prec/g; # takes precision field into account if any

    # TODO work out the concept of composite type
    # $sqltype =~ s/%CT/$comptype/g; # takes composite type into account if any 

    unless ($disable_null) 
    {
      $sqltype .= " NOT" if ($nullable eq 'no');
      $sqltype .= " NULL";
    }

    $entry->{sqltype_hash} = $typedef;
    $entry->{sqlclass_hash} = $class;
    $entry->{sqltype} = $sqltype;

    return $class; 

}

1;








