#include <stream.h>
#include <string>
#include <stdio.h>
#include "utility.h"

// A faire : Gérer un code d'erreur qui ne puisse pas être 
// décrémenté

Utility::Utility(const char *  name, 
                 const char *  copyright,
		 const int     version_major,
		 const int     version_minor,
		 const RLScope status)
{
  strncpy(aname, name, MAXNAMELEN);
  strncpy(acopyright, copyright, MAXNAMELEN);
  aversion_major = version_major;
  aversion_minor = version_minor;
  astatus = status;
}

void Utility::Success()
{
   exit(0);
}

void Utility::Failure(int code)
{
   exit(code);
}

int Utility::Run()
{
  cout << aname << " [ v " << aversion_major << '.' << aversion_minor << endl;
  cout << "Auteur : " << acopyright << '-' << "Statut : ";
  
  switch(astatus)
    {
    case rl_private     : cout << "privée (développement)"; break;
    case rl_restricted  : cout << "restreinte (tests)"; break;
    case rl_full        : cout << "public (complet)"; break;
      //default:              cout << "Statut inconnu"; 
    }

  Banner();
  Go();
  Success();
}




