#include <stdlib.h>
#include <string.h>
#include "encrypt.h"
#include "options.h"
#include "utils.h"
#include "prime_numbers.h"

ciphermode opt_cm;
char	   fname [ 512 + 1 ];

void Banner()
{
   println("Encrypt v0.1 - Encryption software");
   println("Copyright (c) 1999 - Pascal Munerot");
   println("");
}

void Usage()
{
   println("Usage:: ");
   println("  encrypt arguments");
   println("");
   println("    arguments can be the following : ");
   println("    -encrypt :: cipher mode [default]");
   println("    -decrypt :: decipher mode");
   println("    -fname   :: get file(s) name(s) (may be a regular expression)");

}


char * getarg(int index, int argc, char * argv[])
{
  if (index < argc) { return argv[index]; }
  throw "Out of bound index";
}

bool GetOptions(int argc, char * argv[])
{
  OptionsParser op(argc, argv);
  int count = 0;
  if (op.HasArgument("-encrypt")) 
  { 
      println("-encrypt");
      opt_cm = cm_encrypt; 
  }

  if (op.HasArgument("-decrypt")) 
  {
      println("-decrypt"); 
      opt_cm = cm_decrypt; 
  }

  char * tmp = op.ArgumentValue("-fname");
  if (tmp != 0)
  {
      strcpy(fname, tmp);
      println("-fname"); 
      println(fname); 
  }

  char * num = op.ArgumentValue("-isprime");
  if (num != 0)
  {
    if (isprime(atoi(num)) == true) { print(num); println(" est permier !\n\n"); }
    else { print(num); print(" n'est pas premier !\n\n"); }
  }

  num = op.ArgumentValue("-sp");
  char * num2 = op.ArgumentValue("-ep");
  if ((num != 0) & (num2 !=0))
  {
    unsigned long primesstart = atoi(num);
    unsigned long primesend = atoi(num2);
    unsigned long i = 0;
    for (i=primesstart; i<=primesend; i++) 
      if (isprime(i)) { print(i); print("\n"); }
  }
  return false;

}

int main(int argc, char * argv[])
{
   Banner();
   if (!GetOptions(argc, argv)) { Usage(); }
}



