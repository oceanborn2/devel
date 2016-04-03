// filereader.cc - Lecteur de fichiers avec fonction callback
// Auteur : Pascal Munerot.
// Historique : Cree le 22/01/99

// La classe FileReader implemente un lecteur de fichier texte capable d'appeler une fonction
// callback pour chacune des lignes du fichier. La methode CallBack peut etre implementee
// au niveau concret par le programmeur.

#include <string.h>
#include <stream.h>
#include <g++/Regex.h>

#include "filereader.h"
#include "display.h"

// Variables globales
char dirname[MAXPATHLEN];
char fname[255];
char cmdline[MAXCMDLEN+1];    // La ligne de commande

FileReader::FileReader(char * filename, const char * regex=NULL)
{
  strcpy(fname, filename);
  fp = new ifstream(fname);
  if (regex != NULL)
     {  reg = new Regex(regex);
        if (!reg->OK()) { delete reg; reg = NULL; } // Verification de validite de l'expression reguliere
     }
  else reg = NULL;  
}

FileReader::~FileReader()
{
  delete fp; 
  if (reg != NULL) delete reg;
}


void FileReader::Iterator(FileReaderHandler p)
{
  char str[MAXLINELEN];
  while (!fp->eof())
    {
      fp->getline(str,MAXLINELEN,'\n');       // Lecture de la ligne
      p(str);
    }  
} 













