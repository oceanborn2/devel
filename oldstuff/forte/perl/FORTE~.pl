#!/usr/bin/perl -w

$ident = "([a-zA-Z_][a-zA-Z0-9_]*)";   # RE d'un identificateur
$repre = "\@\@$ident\@\@";	       # RE d'un symbole à évaluer
$test = 'print "$line\n";';

$in_script = 0;
$init  = "";


while (defined ($spec = <DATA>))
  {
    chomp($spec);

    # 1ère partie du script
    if ($spec =~ m/^\[init\]/)   { $cat = \ $init; next; }
    if ($spec =~ m/^\[script\]/) { $in_script++; next; }

    print "$spec\n";

    # 2ème partie du script
    next unless $script;      # En mode script, on continue !
    if ($spec =~ m/$repre/g)  # remplacement automatique des symboles par leur valeur
      { 
        $atom=$1; 
        $spec =~ s/$&/$$atom/g; 
      } 

  }
  

__DATA__

[init]
#!/usr/bin/perl -w
print "Analyse du fichier $fname\n";

[script]

@@init@@
while ($line = <>)
  {
    @@test@@
    chomp($line);
    if ($line=~ m/^begin TOOL $ident/) { print "$1\n" };
  }
