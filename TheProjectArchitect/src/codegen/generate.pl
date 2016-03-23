#!/usr/bin/perl

# $Id: generate.pl,v 1.13 2002/07/13 17:23:00 munerot Exp $
#
# $Log: generate.pl,v $
# Revision 1.13  2002/07/13 17:23:00  munerot
# Build is now independant of the project root dir
#
# Revision 1.12  2002/05/18 19:06:34  pascal
# Modified in order to accomodate XML configuration (just starting)
#
# Revision 1.11  2002/04/20 12:56:03  pascal
# Added a new handler for generating exception classes for each business objects
#
# Revision 1.10  2002/04/14 20:52:34  pascal
# Added new handlers, new imports ... essentially for handling the generation of EJBs (in progress) and for some fixes to the existing
#
# Revision 1.9  2001/12/18 01:07:19  pascal
# Added a new handler 'dbobject' for the business object persistance and also added the idea of sticky import to java code generation (via java.pm)
#
# Revision 1.8  2001/12/17 23:58:31  pascal
# Added unique names handling, corrected a name strategy bug for template 'sql_insert'
#
# Revision 1.7  2001/12/17 17:34:49  pascal
# Added new directory 'utils' to shelter utility classes
#
# Revision 1.6  2001/12/09 23:02:07  pascal
# Lots of improvements - SQL now works and java just got better
#
# Revision 1.5  2001/12/07 22:08:56  pascal
# updated perl header
#
# Revision 1.4  2001/12/06 21:36:48  pascal
# cvs tags corrected
#
# Revision 1.3  2001/12/06 21:31:06  pascal
# Added cvs tags
#
# $Author: munerot $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#

use Getopt::Long;
use Env;

sub BEGIN {
    push(@INC, "./lang");
    push(@INC, "./utils");
}

use codegen;
use utils::uniquenames;
use lang::generic;
use lang::java;
use lang::sql;
use strict;
use XML::DOM;

my $BUSOBJ_ROOT;
my $VALUEDOMAIN_ROOT;
my $TEMPLATES_ROOT;
my $REPOSITORY_ROOT;

# reading options from the command line
sub read_options {
    GetOptions('verbose!'  => \$codegen::verbose,
	       'show-gen!' => \$codegen::show_gen,
	       'fname=s'   => \$codegen::fname);

   $REPOSITORY_ROOT  = codegen::getRepositoryRoot;
   $TEMPLATES_ROOT   = codegen::getTemplateRoot;

   $BUSOBJ_ROOT      = "$REPOSITORY_ROOT/busobj";
   $VALUEDOMAIN_ROOT = "$REPOSITORY_ROOT/value_domains";
  }

# This will create and return a sub acting as a runtime environment (closure technique on the $selector variable)
sub create_template_selector {
   my $selector = shift; # template file name
   return sub {
    my $output = "";
    my ($template, $vars) = @_;
    $template->process($selector, $vars, \$output) || die "Generation error" .  $template->error() . "\n";
    return $output;
   };
}

# Example use
# my $sih = create_template_selector("$TEMPLATE_ROOT/sql_insert.tpl");

### SQL_INSERT_TABLE ###
my $sih =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $sql_template  = "$TEMPLATES_ROOT/sql_insert.tpl";
    $template->process($sql_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### SQL_CREATE_TABLE ###
my $scth =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $sql_template  = "$TEMPLATES_ROOT/sql_create_table.tpl";
    $template->process($sql_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### BOBJECT ###
my $bh =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/bobject.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### BOBJECTEXC ###
my $bhexc =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/bobjectexc.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### DBOBJECT ###
my $dbh =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/dbobject.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### VALUE_DOMAIN ###
my $vdh =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/valuedomain.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
  };

### CLISERV ###
my $clsrv =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/cliserv.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
};

### HOMESERV ###
my $homesrv =
sub {
    my $output = "";
    my $template = $_[0];
    my $vars = $_[1];
    my $java_template = "$TEMPLATES_ROOT/homeserv.tpl";
    $template->process($java_template, $vars, \$output) || die "Generation error: ", $template->error(), "\n";
    return $output;
};

# Naming strategies
my $default_name_strategy = sub { my ($name, $ext) = @_; return "$name.$ext"; };
my $sql_insert_name_strategy = sub { my ($name, $ext) = @_; return "${name}_insert.$ext"; };
my $sql_create_name_strategy = sub { my ($name, $ext) = @_; return "${name}_create.$ext"; };
my $bobject_name_strategy = sub { my ($name, $ext) = @_; return "${name}Desc.$ext";  };
my $bobjectexc_name_strategy = sub { my ($name, $ext) = @_; return "${name}Exception.$ext";  };
my $dbobject_name_strategy = sub { my ($name, $ext) = @_; return "${name}Dbms.$ext";  };
my $value_domain_name_strategy = sub { my ($name, $ext) = @_; return "${name}ValueDomain.$ext"; };
my $cliserv_name_strategy = sub { my ($name, $ext) = @_; return "${name}Client.$ext"; };
my $homeserv_name_strategy = sub { my ($name, $ext) = @_; return "${name}Home.$ext"; };


# program entry point
read_options;

# Names support instantiations
my $sql_tables_names_support        = utils::uniquenames->new (1, 30, "TPA_", 1, "_", 1, 0);
my $sql_fields_names_support        = utils::uniquenames->new (1, 30, undef , 0, "_", 0, 1);
my $java_fields_names_support       = utils::uniquenames->new (0, 64, undef , 0, "_", 0, 1);
my $java_value_domain_names_support = utils::uniquenames->new (1, 30, undef , 1, "_", 0, 1);
my $java_services_names_support     = utils::uniquenames->new (1, 30, undef,  1, "_", 0, 1);

##########################
### SQL_INSERT_HANDLER ###
##########################
my $SQL_INSERT_HANDLER =
GenHandler->new
(
        "sql_insert", $sih,
	"sql", "busobj", "generating sql queries",
	$sql_insert_name_strategy, lang::sql->new
);
$SQL_INSERT_HANDLER->setNamesSupport("tablename", $sql_tables_names_support);
$SQL_INSERT_HANDLER->setNamesSupport("sqlfield", $sql_fields_names_support);
codegen::register_handler $SQL_INSERT_HANDLER;

##########################
### SQL_CREATE_HANDLER ###
##########################
my $SQL_CREATE_HANDLER =
GenHandler->new
(
	"sql_create_table", $scth,
	"sql", "busobj", "generating sql queries",
	$sql_create_name_strategy, lang::sql->new
);
$SQL_CREATE_HANDLER->setNamesSupport("tablename", $sql_tables_names_support);
$SQL_CREATE_HANDLER->setNamesSupport("sqlfield" , $sql_fields_names_support);
codegen::register_handler $SQL_CREATE_HANDLER;

##########################################################################################################################################

my $java_bobject = lang::java->new;
$java_bobject->registerStickyImport("java.io.Serializable");

my $BOBJECT_HANDLER =
    GenHandler->new(
	"bobject", $bh,
	"java" , "busobj", "generating business objects",
	$bobject_name_strategy, $java_bobject
);
$BOBJECT_HANDLER->setNamesSupport("tablename", $sql_tables_names_support);
$BOBJECT_HANDLER->setNamesSupport("sqlfield" , $sql_fields_names_support);
$BOBJECT_HANDLER->setNamesSupport("javafield", $java_fields_names_support);

codegen::register_handler $BOBJECT_HANDLER;
##########################################################################################################################################

my $java_bobjectexc = lang::java->new;
$java_bobjectexc->registerStickyImport("java.lang.Exception");
$java_bobjectexc->disableTypeImports;
my $BOBJECTEXC_HANDLER=
    GenHandler->new(
	"bobjectexc", $bhexc,
	"java" , "busobj", "generating business objects exceptions",
	$bobjectexc_name_strategy, $java_bobjectexc
);
codegen::register_handler $BOBJECTEXC_HANDLER;

##########################################################################################################################################

my $java_dbms = lang::java->new;
$java_dbms->disableTypeImports;
$java_dbms->registerStickyImport("java.sql.*");
$java_dbms->registerStickyImport("java.lang.StringBuffer");
$java_dbms->registerStickyImport("java.util.Vector");
$java_dbms->registerStickyImport("java.util.Hashtable");


my $DBOBJECT_HANDLER =
    GenHandler->new(
	"dbobject", $dbh,
	"java" , "busobj", "generating persistance for business objects",
	$dbobject_name_strategy, $java_dbms
);
$DBOBJECT_HANDLER->setNamesSupport("tablename", $sql_tables_names_support);
$DBOBJECT_HANDLER->setNamesSupport("sqlfield" , $sql_fields_names_support);
$DBOBJECT_HANDLER->setNamesSupport("javafield", $java_fields_names_support);
codegen::register_handler $DBOBJECT_HANDLER;

##########################################################################################################################################
my $java_valdom = lang::java->new;
$java_valdom->registerStickyImport("java.util.Hashtable");
$java_valdom->registerStickyImport("java.util.Enumeration");
$java_valdom->registerStickyImport("ops.frm.valuedomains.ValueDomain");

my $VALUE_DOMAIN_HANDLER =
    GenHandler->new(
	"value_domain", $vdh,
	"java", "valuedomains", "generating value domains",
	$value_domain_name_strategy, $java_valdom
);
$VALUE_DOMAIN_HANDLER->setNamesSupport("tablename", $sql_tables_names_support);
$VALUE_DOMAIN_HANDLER->setNamesSupport("sqlfield" , $sql_fields_names_support);
$VALUE_DOMAIN_HANDLER->setNamesSupport("javafield", $java_fields_names_support);
$VALUE_DOMAIN_HANDLER->setNamesSupport("valdomid" , $java_value_domain_names_support);

codegen::register_handler $VALUE_DOMAIN_HANDLER;

##########################################################################################################################################
my $java_cliserv = lang::java->new;
$java_cliserv->registerStickyImport("java.util.Properties");
$java_cliserv->registerStickyImport("javax.naming.Context");
$java_cliserv->registerStickyImport("javax.naming.InitialContext");

my $CLIENT_SERVICE_HANDLER=
    GenHandler->new(
	"cliserv", $clsrv,
	"java", "services", "generating services",
	$cliserv_name_strategy, $java_cliserv
);
codegen::register_handler $CLIENT_SERVICE_HANDLER;

##########################################################################################################################################
my $java_homeserv = lang::java->new;
$java_homeserv->registerStickyImport("javax.ejb.EJBHome");
$java_homeserv->registerStickyImport("javax.ejb.CreateException");
$java_homeserv->registerStickyImport("java.rmi.RemoteException");

my $HOME_SERVICE_HANDLER=
    GenHandler->new(
	"homeserv", $homesrv,
	"java", "services", "generating services",
	$homeserv_name_strategy, $java_homeserv
);
codegen::register_handler $HOME_SERVICE_HANDLER;

####################################################################################################################################################################################################################################################################################

my $TPA_DIR=$ENV{PWD};
$TPA_DIR =~ s/build$//;
print "TPA_DIR variable set to : $TPA_DIR\n";

codegen::process_directory "${TPA_DIR}/src/specs/busobj", ".*",
(
 "sql_insert",
 "sql_create_table",
 "bobject",
 "bobjectexc",
 "dbobject"
);

codegen::process_directory "${TPA_DIR}/src/specs/value_domains", ".*",
(
 "value_domain"
);

codegen::process_directory "${TPA_DIR}/src/specs/services", ".*",
(
 "cliserv",
 "homeserv"
);

__END__












