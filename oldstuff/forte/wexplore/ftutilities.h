#ifndef __FTUTILS_H__
#define __FTUTILS_H__

#include "utility.h"

class ForteUtility : public Utility
{
 public:
  ForteUtility(const char *  name,
	       const char *  copyright,
	       const int     version_major,
	       const int     version_minor,
	       const RLScope status)
    
    : Utility(name, copyright, version_major, version_minor, status) {}
  ~ForteUtility() {}
};


#endif






