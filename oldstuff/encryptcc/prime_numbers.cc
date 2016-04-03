#include <iostream.h>
#include <math.h>
#include "prime_numbers.h"


bool isprime(unsigned long x)
{
  bool res = true;
  unsigned long i = 0;
  unsigned long rac = (unsigned long) (sqrt(x)+1);
  for (i=2; i<rac; i++)
    {
      if (x % i ==0) 
	{
	   res = false;
           break;
	}
    }
  return res;  
}






