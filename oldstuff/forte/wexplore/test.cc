#include <stdio.h>
#include <stream.h>

#include "display.h"
#include "filereader.h"

int wc = 0;

void Banner()
{
  outline("Programme de test de la classe FileReader");
}

void Usage()
{
  outline("Le nom du fichier n'a pas ete precise");
  exit(1);
}

void HandleString(char * str)
{
  outline(str);
  wc++;
}

void DisplayLineCount()
{
  outline("");
  out("Nombre de lignes dans le fichier : ");
  cout << wc << endl;
}

void Proceed(char * fname, const char * reg)
{
  FileReader fr (fname,reg);
  fr.Iterator(HandleString);
  DisplayLineCount();
}

int main(int argc, char *argv[])
{
  Banner();
  if (argc < 2) Usage();
  if (argc > 2) Proceed(argv[1],argv[2]);
  else          Proceed(argv[1],NULL);
 }

























