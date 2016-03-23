#!/usr/bin/perl

# $Id: generate2.pl,v 1.1 2002/05/18 19:05:48 pascal Exp $
#
# $Log: generate2.pl,v $
# Revision 1.1  2002/05/18 19:05:48  pascal
# Temporarily added for allowing a major change : configuration per project of the code generation system will soon be based on an XML file
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
# $Author: pascal $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#

use Getopt::Long;

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
use Data::Dumper;

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

sub parseCodegen {
    my $fname = shift;
    print "parsing codegen file : $fname\n";
    my $parser = XML::DOM::Parser->new;
    my $doc = $parser->parsefile($fname);

    my %specs;

    # Name strategies
    my %namestrategies;
    foreach my $node ($doc->getElementsByTagName('namestrategy')) {
      my $id = $node->getAttribute('id');
      my $perlcode = $node->getFirstChild->getData;
      $namestrategies{$id}=$perlcode;
    }

    # Unique names support
    my %uniquenamesupport;
    foreach my $node ($doc->getElementsByTagName('uniquenamesupport')) {
      my $id           = $node->getAttribute('id');
      my $chm          = lc $node->getAttribute('casehandling');
      my $casehandling = $chm eq 'none' ? 1 : ($chm eq 'upper' ? 2 : 3);
      my $maxlen       = $node->getAttribute('maxlen');
      my $prefix       = $node->getAttribute('prefix');
      my $spacesubst   = $node->getAttribute('spacesubst');
      my $procspecnode = $node->getAttribute('procspecnode');
      my $procentries  = $node->getAttribute('procentries');
      $uniquenamesupport{$id}=utils::uniquenames->new(
        $casehandling, $maxlen, $prefix, defined($prefix) ? 1 : 0, $spacesubst, $procspecnode, $procentries);

    }

    # Language support
    my %languages;
    foreach my $node ($doc->getElementsByTagName('languagesupport')) { $languages{$node->getAttribute('name')}=1; }

    # Data models
    my %datamodels;
    foreach my $node ($doc->getElementsByTagName('datamodel')) {
       my $id = $node->getAttribute('id');
       my $comment = $node->getAttribute('comment');
       my @paths;
       foreach my $path ($node->getElementsByTagName('path')) {
	   my $deep = $path->getAttribute('deep');
	   my $pattern = $path->getAttribute('pattern');
	   my $dir2proc= $path->getFirstChild->getData; # TODO Error control here (first child may not exist)
	   push(@paths, { deep => $deep, pattern => $pattern, dir2proc => $dir2proc });
       }
       $datamodels{$id}= { id => $id, comment => $comment, paths => \@paths }; # TODO Transform this into a full fledged object package       
    }

    # Handler definitions
    my %handlers;

    foreach my $node ($doc->getElementsByTagName('handler')) {

	my $id = $node->getAttribute('id');

	my @imports;
	foreach my $importrow ($node->getElementsByTagName("import")) {
	    my $importclause = $importrow->getFirstChild->getData;
	    my $trimext      = $importrow->getAttribute('trimext');
	    push(@imports, { importclause => $importclause, trimext => $trimext }); 
	}

	my @languages;
	foreach my $languagenode ($node->getElementsByTagName("language")) {
	    push(@languages, $languagenode->getAttribute('name'));	    
	}

	my @namesupports;
	foreach my $namesupportnode ($node->getElementsByTagName("namesupport")) {
	    my $nsid = $namesupportnode->getFirstChild->getData;
	    my $var = $namesupportnode->getAttribute('var');
	    push(@namesupports, { id => $nsid, var => $var });
	}
	$handlers{$id}= { imports     => \@imports, 
			  languages   => \@languages, 
			  namesupport => \@namesupports };
    }

    # generate associations
    my %generate;
    foreach my $node ($doc->getElementsByTagName('generate')) {
	my $datamodel = $node->getAttribute('datamodel');
	my @targethandlers;
	foreach my $targetnode ($node->getElementsByTagName('target-handler')) {
	    my $target_handler = $targetnode->getFirstChild->getData;
	    push(@targethandlers, $handlers{$target_handler});
	}
	$generate{$datamodel} = { handlers => \@targethandlers, datamodel => $datamodels{$datamodel} };
    }

    print Dumper(%generate);

}


parseCodegen "/home/pascal/TheProjectArchitect/src/codegen/handlers.xml";
exit(0);

