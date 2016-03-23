package codegen;

# $Id: codegen.pm,v 1.7 2002/04/14 20:51:21 pascal Exp $
#
# $Log: codegen.pm,v $
# Revision 1.7  2002/04/14 20:51:21  pascal
# started with the recursive processing of entries' children elements. Not done yet.
#
# Revision 1.6  2001/12/17 17:34:49  pascal
# Added new directory 'utils' to shelter utility classes
#
# Revision 1.5  2001/12/09 23:02:17  pascal
# Lots of improvements - SQL now works and java just got better
#
# Revision 1.4  2001/12/06 21:36:08  pascal
# Added cvs tags
#
# $Author: pascal $
#
# This file belongs to the 'Project Architect' and is released under the GNU General Public License (GPL)
#
# Copyright (C) Pascal Munerot
#

use strict;
use Template;
use XML::DOM;
use File::Find;
use File::Path;
use File::Spec;
use Getopt::Long;
use GenHandler;
use Data::Dumper;
use Date::Calc;

my @handlers; # handlers to be processed
my %handlers; # handlers hash

my $SRC_SUBDIR;
my $SPECS_SUBDIR;
my $GENERATED_SUBDIR;
my $TEMPLATES_SUBDIR;
my $CODEGEN_SUBDIR;
my $PROJECT_ROOT;
my $SOURCES_ROOT;
my $CODEGEN_ROOT;
my $GENERATED_ROOT;
my $TEMPLATES_ROOT;
my $REPOSIT_ROOT;

my $parser;
my $verbose;
my $show_gen;
my $template;
my $fname;

# directories declarations - Shall improve that later
BEGIN {
    $SRC_SUBDIR        = "src"; 
    $SPECS_SUBDIR      = "specs";
    $GENERATED_SUBDIR  = "generated";
    $TEMPLATES_SUBDIR  = "templates";
    $CODEGEN_SUBDIR    = "codegen";
    $PROJECT_ROOT      = "/home/pascal/TheProjectArchitect";  
    $SOURCES_ROOT      = "$PROJECT_ROOT/$SRC_SUBDIR";
    $CODEGEN_ROOT      = "$SOURCES_ROOT/$CODEGEN_SUBDIR";
    $GENERATED_ROOT    = "$SOURCES_ROOT/$GENERATED_SUBDIR";
    $TEMPLATES_ROOT    = "$SOURCES_ROOT/$TEMPLATES_SUBDIR";
    $REPOSIT_ROOT      = "$SOURCES_ROOT/$SPECS_SUBDIR";

    # global variables - Find a better way to do that (hash-table?)
    $| = 1;
    $verbose  = 0;
    $show_gen = 0;
    $fname = undef;
    $parser = XML::DOM::Parser->new(); # XML parser (DOM)
    $template = undef;
}

# some methods to retrieve data items from the package
sub getTemplateRoot   { return $TEMPLATES_ROOT; }
sub getSourcesRoot    { return $SOURCES_ROOT; }
sub getRepositoryRoot { return $REPOSIT_ROOT; }

# echo a fatal error message and exits with error code positionned
sub fatal {
    my $msg = shift or "";
    print "fatal : $msg\n"; # TODO Send this string to stderr
    exit(1);
}

# utility method for retrieved attributes out of an XML element
sub get_element_attributes {
    my $element_node = shift;
    my $namednodemap  = $element_node->getAttributes;
    my $len = $namednodemap->getLength;
    return undef if ($len == 0);

    my %res;
    for my $i (0..$len-1) { 
	my $item  = $namednodemap->item($i++);
	my $name  = $item->getName;
	my $value = $item->getValue;
	$res{$name}=$value;
    }
    return \%res;
}

# gets handler from parameters and runs the specification (ie processes it) 
sub run_specification {
    my $vars    = shift; 
    my $handler = $vars->{handler}; # handler definition hash
    return unless (defined($handler) && defined($vars)); 
    return &$handler($template, $vars);
}

# Opens a file for read-write and appends the string passed as parameter to it
sub create_file_with_string {
    my $outname = shift;
    my $output_stream = shift;
    print "> $outname\n" if $verbose;
    open(OUT, ">$outname"); print OUT $output_stream; close(OUT); 
    print $output_stream if ($show_gen);

}

# Makes sure a given path exists (TODO Reimplement with File::Path and File::Spec). If any subdirectory is missing the creates it
sub ensure_path_exists {
    my $path = shift;
    my $cut_path =  $path;

    $cut_path =~ s/$SOURCES_ROOT//; # sandbox : avoid tinkering with directories outside the project root. Also faster
    my @subdirs = split (/\//, $cut_path);

    # loop over each subdirectory, try to chdir, tries to create the directory if chdir fails
    my $dir = $SOURCES_ROOT;

    foreach my $subdir (@subdirs) {
	next if ($subdir eq "");
	$dir .= "/$subdir";
	fatal ("The '$subdir' subdirectory in '$path' is not a directory") if (-f $dir || 
									       -l $dir);
	if (-d $dir) { print "ok, directory '$subdir' exists in '$dir'\n" if $verbose; }
	else { 
	    print "we need to create the '$subdir' directory in '$dir'\n" if $verbose;
	    mkdir $dir;
	}
    }
}

# Given a path, returns a package name, taking into account the sources' root directory
sub convert_path_to_package {
    my $path = shift;
    my $packagename = $path;
    $packagename =~ s|$SOURCES_ROOT/generated||; 
    $packagename =~ s|/|.|og;
    $packagename =~ s|^\.||;
    print "path '$path' converted to package name '$packagename'\n" if $verbose;
    return $packagename;
}

# Register a new handler by its name 
sub register_handler
{
    my $handler_ref = shift;
    my $type = $handler_ref->getType;
    $handlers{$type}= $handler_ref;
    return $handler_ref; # mostly for convenience
}

# Returns a reference to an handler given its name
sub get_handler_definition
{
    my $type   = shift; return unless defined($type);
    my $handler = $handlers{$type} || sub { fatal("Could not find handler for type $type"); };
    return $handler;
}

# computes current timestamp
sub getCurrentTimeStamp {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday);
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime(time);
    $year+=1900;
    my $res="$mday/$mon/$year $hour:$min:$sec";
    return $res;
}

# processes entries children nodes and attributes recursively and converts them into a perl datastructure
sub map_children {
    my $entry_node = @_;
    my $children = $entry_node->getChildrenNodes;
    my $count = $children->getLength;

    my $result = undef;
    foreach my $index (0..$count-1) {
	print ".";
	
    }
}


# reads a specification file written in xml
sub process_specification {
    my $fname = $_;
    return if (-d $fname);
    return unless (defined($fname) && $fname ne '.' && $fname ne '..' && $fname !~ m/.xml~/);


    my $input_path  = $File::Find::dir;
    my $output_path = $input_path; # temporary
    $output_path =~  s|/$SRC_SUBDIR/$SPECS_SUBDIR/|/$SRC_SUBDIR/$GENERATED_SUBDIR/ops/app/pa/|; # substitutes 'specs' with 'generated'
										     # in subdirectory name
    my $issubdir = 1 if (-d "$input_path/$fname");
    print "subdirectory : $fname\n" if ($issubdir && $verbose);
    return if ($issubdir);

    my $packagename = convert_path_to_package($output_path);

    print "&+ $output_path\n" if ($verbose);
    ensure_path_exists $output_path;
    print "parsing $input_path/$fname: " ; #if $verbose;

    my ($name, $type);
    my $doc;
    eval {
	$doc = $parser->parsefile($fname);
    };
    print ($@ ? $@ : "OK");
    print "\n";


    foreach my $spec ($doc->getElementsByTagName('spec'))
    {
	 # dealing with everything at the element (in xml speak) level
	 $name = $spec->getAttribute('name');  # object name
	 $type = $spec->getAttribute('type');  # model to be considered (type of data)

	 # convert to a basic perl array
	 my $spec_attributes = get_element_attributes($spec);

	 # dealing with entries (aka children of the spec node)
	 my @nodes = $spec->getElementsByTagName("entry");
	 my @modelentries = ();

	 # Iterate over each node in the current spec
	 foreach  my $node (@nodes)
	 {
	    my $attributes = get_element_attributes($node); # Attributes for the current node
	    my $children   = undef; #map_children($node); # Children nodes, recursively
#	    $attributes->{_children_} = $children; # Children nodes are stored as an attribute
	    push(@modelentries, $attributes);
         }

	 # iterate over each handler
	 foreach my $local_handler (@handlers)
	 {
	    # Copies entries from the modelentries (just read from the specs nodes)
	    my @entries = @modelentries; # initialises entries from @modelentries

	    # gets handler and output filename
	    my $handler_ref  = get_handler_definition($local_handler);
	    my $ext	     = $handler_ref->getExt;
	    my $namestrategy = $handler_ref->getNameStrategy;

	    my $ofname = &$namestrategy ($name, $ext);
    	    my $outname  = "$output_path/$ofname";
	    $spec_attributes->{outputfilename}=$ofname;
	    $spec_attributes->{fulloutputfilename}=$outname; # is it any useful ?
	    $spec_attributes->{generationtimestamp}= getCurrentTimeStamp;

	    # Language type support - We invoke an object derived from lang/generic.pm
	    # This object support preprocessing, processing of each entry, and postprocessing
	    # It implements the behaviour needed for generating the target languages.

	    # Among the tasks to be achieved : calculating values for the context (imports ...).
	    $handler_ref->setSpecNode($spec_attributes); # necessary for attributes at the specification level (not at the entry level)
	    my $language_support = $handler_ref->getLanguageSupport;
	    $language_support->runSpec($handler_ref, \@entries);
	    my $globals = $handler_ref->getGlobals;

	    # Generate code into a string
            my $output_stream = run_specification 
            { 
		    handlername => $local_handler,
		    handler     => $handler_ref->getHandler,
		    name        => $name, 
		    type        => $type,
		    entries     => \@entries ,     
		    spec        => $handler_ref->getSpecNode,
		    packagename => $packagename,
		    globals     => $globals
            };

	    $handler_ref->setSpecNode(undef); # some cleanup

	    create_file_with_string $outname, $output_stream; # create file with generated string
	}
    }
}


# Processes a whole directory given the directory and a pattern
sub process_directory {

    my $inputdir = shift;     # gets directory to be processed
    my $file_pattern = shift; # gets pattern for files
    return undef unless defined($file_pattern);

    @handlers = @_;        # gets remaining parameters as a list of handlers
    print "+< $inputdir\n" if $verbose;

    # initializing the template system
    $template = undef; # make sure it goes to garbage if previously defined
    $template = Template->new({
     ABSOLUTE     => 1,
     RELATIVE     => 0,
     POST_CHOMP   => 1,
     EVAL_PERL    => 1,
     INTERPOLATE  => 1,
     INCLUDE_PATH => $TEMPLATES_ROOT
    });

    # recurse into $dir and processes any XML file 

    find(
      { 
	wanted => \&process_specification,

	preprocess => sub {
	    my @res;
	    foreach $_ (@_) {
		s/\s*//;  # remove leading spaces 
		s/\s*$//; # remove trailing spaces 
		next if (-d && /^cvs/ogi);  # do not recurse into cvs directories
		next unless (-d || /\.xml$/ogi); # only parse XML files
		push(@res, $_) ;
	    }
	    return @res;
	} 
      }, $inputdir); # here we go

}

1; 

__END__

=head1 codegen - This package provides a few API to help with the code generation process
=head2 get_element_attributes - return attributes from an element node
=head2 run_specification - # calls template given a context ($vars) and a handler ($handler)
=head2 create_file_with_string - outputs a string to a file
=head2 ensure_path_exists - creates a directory structure (complete or partial 
=head2 convert_path_to_package - converts the directory name to a suitable package name (as default), can be changed by the template or by other means
=head2 register_handler - registers a handler for a given specification type
=head2 get_handler_definition - returns the handler definition given its name












