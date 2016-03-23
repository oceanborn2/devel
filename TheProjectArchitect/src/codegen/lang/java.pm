#
# $Id: java.pm,v 1.6 2002/04/14 20:57:38 pascal Exp $
#
# $Log: java.pm,v $
# Revision 1.6  2002/04/14 20:57:38  pascal
# Added a new processing for handling javabeans names + minor modifiications
#
# Revision 1.5  2001/12/18 01:09:35  pascal
# Added sticky import support
#
# Revision 1.4  2001/12/17 23:50:18  pascal
# Added unique name handling, changed datatype attribute name from 'type' to datatype
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

package lang::java;

use lang::generic;

@ISA=qw(lang::generic);

sub clearImports {
    my $obj = shift;
    $obj->{imports}=undef;
    return $obj;
}

sub registerStickyImport {
    my ($obj, $class) = @_; # class is a fully qualified classname (ie with package information), represented as a string
    $obj->{sticky_imports}{$class}=1;
    return $obj;
}

sub registerImport {
    my ($obj, $class) = @_; # class is a fully qualified classname (ie with package information), represented as a string
    $obj->{imports}{$class}=1;
    return $obj;
}

sub getImports {
    my $obj = shift;
    my @res = keys %{$obj->{imports}};
    foreach my $sticky (keys %{$obj->{sticky_imports}}) {
	push(@res, $sticky);
    }
    return \ @res;
}

sub getImportsAsCode {
    my $obj = shift;
    my $outstring = "";
    my @imps = @{$obj->getImports};
    foreach my $imp (@imps) {
	$imp =~ s/^\s*//og;
	$imp =~ s/\s*$//og;
	next unless (defined($imp) && $imp ne "");
	$outstring .= "import $imp;\n";
    }
    return $outstring;
}

# compute the type given its xml type and size
sub computeType {

    my ($obj, $handler_ref, $entry) = @_;

    my $datatype  = $entry->{datatype};        # input type (ie generic type)
    return unless defined ($datatype);

    my $typedef	= $obj->SUPER::getTypeDef($datatype,'java');
    my $defaultsize = $typedef->{defaultsize};
    my $defaultprec = $typedef->{defaultprec};

    my $size  = $entry->{size} || $defaultsize || 1;
    my $prec  = $entry->{precision} || $defaultprec;
    my $primitive_def = $typedef->{primitive};
    my $object_def    = $typedef->{object};

    my $class   =
	{
	   imports   => $typedef->{imports},
           object    => $object_def,
           primitive => $primitive_def,
           bytesize  => $typedef->{bytesize},
	   size      => $size,
	   prec      => $prec,
	   signed    => $typedef->{signed}
	};

    my $javatype;
    my $wants_primitive = $entry->{primitive}; # does the entry requires a primitive type ? (true value => yes)
    $wants_primitive = 0 unless defined($primitive_def); # check that one is available in the type definition
    $javatype = $wants_primitive ? $primitive_def : $object_def; # gets correct type

    $javatype =~ s/%SZ/$size/g; # takes size field into account if any
    $javatype =~ s/%PR/$prec/g; # takes precision field into account if any

    # TODO Work out the concept of composite type
    # $javatype =~ s/%CT/$embtype/g; # takes precision field into account if any

    $obj->registerImport($class->{imports}) unless ($wants_primitive);

    $entry->{javatype_hash} = $typedef;
    $entry->{javaclass_hash} = $class;
    $entry->{javatype} = $javatype;

    return $class;

}

# computes a correct bean name (TODO:Investigate the correct rules)
sub computeBeanName {
    my ($obj, $handler_ref, $entry) = @_;
    $entry->{javabean_name} = ucfirst $entry->{name};
}

sub preProcess {
    my ($obj, $handler_ref, $entries) = @_;
    $obj->clearImports;

    # Computing optional global datatype
    my $specnode = $handler_ref->getSpecNode; # recovers attributes from the spec node
    my $datatype = $specnode->{datatype};
    if (defined($datatype)) {
	my $class = $obj->computeType($handler_ref, $specnode); # It is not a true entry
    }

}

sub postProcess {
    my ($obj, $handler_ref, $entries) = @_;

    my $imports = $obj->getImports();
    my $imports_as_code = $obj->getImportsAsCode();

    my %globals;
    $globals{imports}=$imports;
    $globals{imports_as_code}=$imports_as_code;
    $handler_ref->setGlobals(\%globals);
}

sub processEntry {
    my ($obj, $handler_ref, $entry) = @_;
    $obj->computeType($handler_ref, $entry);
    $obj->computeBeanName($handler_ref, $entry);
}

1;






