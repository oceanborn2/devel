#ifndef __FILEREADER_H__
#define __FILEREADER_H__

#include <fstream.h>
#include <g++/Regex.h>

const int MAXFNAMELEN = 255;  // Longueur maximale d'un nom de fichier complet
const int MAXLINELEN  = 4096; // Longueur maximale d'une ligne
const int MAXPATHLEN  = 512;  // Longueur max d'un nom de repertoire (???)
const int MAXCMDLEN   = 2048;      // Longueur max d'une ligne de commande


// Pointeur de fonction avec comme parametre une chaine C
typedef void FileReaderHandler(char * str);
 
// Iterateur sur fichier
class FileReader
{
 private:
  char      fname[MAXFNAMELEN];
  ifstream  * fp;
  Regex     * reg;
 public:
  FileReader(char * filename, const char * regex=NULL);
 ~FileReader();
  void  Iterator(FileReaderHandler p);
};

#endif











