// wexplode.h -- Entete du programme Wexplore
// Auteur : Pascal Munerot
// Historique : Cree le 22/01/99

// Contient les constantes et les definitions utilisees par le projet wexplore
// ainsi que la définition de la classe Utilitaire (WEXPLODE)

#ifndef __WEXPLODE_H__
#define __WEXPLODE_H__

const int    MAXCMDLEN   = 2048;      // Longueur max d'une ligne de commande

#include <stream.h>
#include "ftutilities.h"

class Wexplode : public ForteUtility
{
 public:
  Wexplode()  (const char *  name,
	       const char *  copyright,
	       const int     version_major,
	       const int     version_minor,
	       const RLScope status)
    
    : ForteUtility(name, copyright, version_major, version_minor, status) {}
 
  void       Usage() {}
  void       Go () { cout << "well done guy !" << endl; }

  ~Wexplode() {}
  
};

#endif












