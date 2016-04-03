#ifndef __UTILITY_H__
#define __UTILITY_H__

#include "options.h"

const int MAXNAMELEN = 128;

typedef enum { rl_none, rl_private, rl_restricted, rl_full } RLScope;

class Utility
{
 private:

  char    aname           [MAXNAMELEN+1];
  char    acopyright      [MAXNAMELEN+1];
  int     aversion_major;
  int     aversion_minor;
  RLScope astatus;

 public:

  Utility(const char *  name, 
          const char *  copyright,
          const int     version_major,
          const int     version_minor,
          const RLScope status);

  ~Utility() {}

  virtual void Success();           // Sortie OK
  virtual void Failure(int code=1); // Sortie KO
          int  Run();
  virtual void Usage() = 0;
  virtual void Banner() { };        // Par defaut, ne fait rien
  virtual int  Go() = 0;            // A implementer.
};

#endif










