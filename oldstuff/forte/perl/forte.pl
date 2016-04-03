#!/usr/bin/perl -w


$argc = @ARGV;
$fname= shift;
print $fname;

die "au revoir!";

unless ($argc > 0) { die "Il faut preciser un nom de fichier a analyser"; }

# Affichage du nom de fichier unique
$banner = "\n" x 3 . "Analyse ";
if ($argc==1) { $banner .= "du fichier source @ARGV"; }
else { $banner .= "des fichiers sources : @ARGV"; }
print $banner;

# Recherche de la chaine dans le(s) fichier(s)

print "\n";
print "Recherche en cours ...";
print "\n";
$projectname = "";
$clsname   = "";
$methodname  = "";
$methodsig   = "";
$methodre = "^method ([a-zA-Z0-9_]+)\.([a-zA-Z0-9_]+)";
 
while (defined($st))
{
   chomp;
   if (/^begin TOOL ([a-zA-Z0-9_]+)/)
   {
       $projectname = $1;
       print "Analyse du projet $projectname\n";
   }		 
   elsif (/"end $projectname"/)
   {
       $projectname = "";
   }
   elsif (/^class ([a-zA-Z0-9_]+)/)
   {
       $clsname = $1;
       print "Analyse de la classe $clsname\n";
   }
   elsif (/end class/) 
   {
       $clsname = "";
   }
   elsif (/$methodre/)
   {
       print "ON A TROUVE UNE METHODE !!!";
       if (!($clsname ne $1)) { die "Le nom de la classe n'est pas coherent : \[$clsname,$1\]"; }
       $methodname = $2;
       s/$methodre//; # supprimer la premiere partie de la declaration de la methode
       $methodsig = "";
       if (/(\(.*)/) # Detection d'une liste de parametres pour la methode 
       { 
           $methodsig = $1; 
	   do 
	   { $_ = <>; # Lecture de la ligne qui suit 
	     $methodsig .= $_;
	   }
	   until ($_ ~= /^begin/);
       }
       print "Signature de la methode : $methodname::$methodsig\n";
   }  
}





















