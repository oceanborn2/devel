#!/usr/bin/perl -w

# Script de decoupage d'un fichier WEX en une serie de fichiers PEX

# expressions regulieres
$projectname = "";
$ident = "[a-zA-Z0-9_]+";
$start_prj = "begin (?:TOOL|C) ($ident)";
$forcedir = 0;
$forcefiles = 0;
$argc = scalar @ARGV;
$usage = 0;
$rootdir = "/home/pascal/comp";

sub GetFullName
{
    my($fname) = $_[0];
    $rep =~ s#/$##;
    if ($rootdir eq ".") { $rep =~ s#^/##; }
    return "$rootdir/$rep/$fname\.pex";
}

sub CreerFichier
{
    my($fname) = $_[0];
    my($fullname) = "";
    close(SORTIE);
    $fullname = GetFullName($fname);
    if (-e $fullname && !$forcefiles)
    { die "Le nom du fichier $fname existe deja"; }
    print "Creation du fichier $fullname ... ";
    open (SORTIE, ">$fullname") || die "Le fichier $fullname ne peut pas etre ouvert : $!";
    print "OK !\n";
}

sub DecouperEnProjets
{
    my($fname) = $_[0]; # Nom du fichier a decouper
    my($rep)   = $_[1]; # Nom du repertoire de destination
    $rep =~ s#/$##;
    die "Fichier introuvable : \"$fname\"" 
    unless (-e $fname); # Verifier l'existence du fichier

    # Acquisition du repertoire et creation si necessaire    
    if (-e "$rootdir/$rep")
    {
     if (!$forcedir) { die "Le nom \"$rep\" est deja utilise"; }
    }
    else 
     { mkdir("$rootdir/$rep",0777) || die "Repertoire $rootdir/$rep : Creation impossible";  }

    # Ouverture du fichier a decouper en lecture seule
    open(FNAME, "<$fname");
    while (defined($line = <FNAME>))
    {
       
       # Detection de la declaration d'un nouveau projet
	if ($line =~ /$start_prj/)
       {
	   $projectname = $1; 
           CreerFichier($projectname);
       }


       print SORTIE $line;

       # Detection de la fin d'un projet
       if ($line =~ /end\s+$projectname/)
       {
	   $projectname = "";
	   close(SORTIE);
       }


    }
    close(FNAME);
}

sub Usage()
{
    print "Wex2Pex - Utilitaire de decoupage de fichier WEX en PEX\n";
    print "\n";
    print "  Usage: wex2pex <nomfichier> <nomrep>\n";
    print "\n";
    print "     nomfichier :: Nom du fichier a decouper\n";
    print "     nomrep     :: Chemin de destination des fichiers\n";
    print "\n\n";
    print "  Options :\n";
    print "    /fd : Continue le traitement meme si le repertoire existe deja!\n";
    print "    /ff : Continue le traitement meme si le fichier existe deja!\n";
    print "    /nr : Le repertoire est positionne a partir du repertoire courant (DECONSEILLE)\n";
    print "    /rd<nomrep> : Repertoire racine (pour la sortie) (DECONSEILLE)\n";

    $usage++;
}

sub LireOptions
{
  if ($argc < 2) { Usage(); }
  else
  {
  foreach $arg (@ARGV)
   {
     if ($arg =~ /^\//) # lecture du caractere / en debut d'arguments
     {
        if    ($arg =~ /h$/) { Usage(); }       
	elsif ($arg =~ /fd$/) { $forcedir++; }
	elsif ($arg =~ /ff$/) { $forcefiles++; }
	elsif ($arg =~ /nr$/) { $rootdir = "."; }
	elsif ($arg =~ /rd([\/a-zA-Z0-9_]+$)/) { print "=== $1\n"; $rootdir = $1; }
     }
   }
  }
}


# Acquisition des parametres
LireOptions();
if ($usage == 0) 
{
  ($name, $rep)  = @ARGV;
  DecouperEnProjets($name, $rep);
}









