#include <string>
#include <stdio.h>
#include <iostream.h>
#include <regex.h> // POSIX

#include "display.h"
#include "filereader.h"
#include "forte.h"

// Variables globales
extern char dirname[MAXPATHLEN];
extern char fname[255];
extern char cmdline[MAXCMDLEN+1];    // La ligne de commande

char prjreg[512];
bool ExtractProjects = false; // Extraction des projets
bool ExtractClasses  = false; // Extraction des classes
 
void Usage()
{
   outline("\nUsage : ");
   outline("  wexplore <fichier-wex> [regex-projet] [repertoire]");
   outline("");
   outline("    regex-projet :: expression régulière pour filtrer les projets");
   outline("                    (doit être comprise entre des guillemets)");
   outline("    fichier-wex  :: nom du fichier wex source");
   outline("    répertoire   :: répertoire de destination des fichiers projets");
   outline("");
   exit(1);
}

void Banner()
{
   outline("Wexplore - Utilitaire d'exploration de fichiers Wex");
   outline("Auteur : Pascal Munerot. Version : v0");
   outline("");
}

void ShowOptions()
{
}

void GetOptions(int argc, char *argv[])
{
   string args;
   for (int i= 1; i<argc; i++) args = args + argv[i];
   cout << "Options = " << args << endl << endl;
}  
     
int CutWexFile()
{
   outline("");
   cout << "Découpage du fichier " << fname << " en cours. Projets réécrits dans le répertoire " \
	<< dirname << endl;
 
}

// Verifie si le début de la ligne correspond a la commande en parametre
bool IsCmd(char * str)
{
  return strncmp(cmdline, str, strlen(str)) == 0;
}


void PromptUser()
{
  cout << "WEXPLORE > ";
  cin.getline(cmdline, MAXCMDLEN, '\n');
}

void Extract()
{
   outline("extraction en cours ...");
   outline("extraction termine !");
}

void Find()
{
   outline("Recherche en cours ...");
   outline("Recherche terminée !");
}

bool GetCommand()
{
   do 
     {
        PromptUser();
        switch(cmdline[0])
	  {

	  case 'c' : 
	    {
	    }


	  case 'f' :
	    {
	        if      (IsCmd("find")) Find();
	    }

	  case 'e' :
	    {
		if      (IsCmd("exit")) break;
		else if (IsCmd("extract "))  Extract(); 
	    }
	  }

     }
     while (!IsCmd("exit"));

   return false;
}

int main(int argc, char * argv[])
{
   Banner();
   GetOptions(argc, argv);
   GetCommand();
   exit(0);
} 



































