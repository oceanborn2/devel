#include <string.h>
#include <stdlib.h>
#include "options.h"
#include "utils.h"

OptionsParser::OptionsParser(int ARGC, char *ARGV[])
{
  this->ARGC = ARGC;
  this->ARGV = (char **) malloc(100); //new (char *) [ARGC]
  for (int i=0; i<ARGC; i++)
  {
    this->ARGV[i] = new char [ strlen(ARGV[i]) + 1 ];
    strcpy(this->ARGV[i], ARGV[i]);
  }
}

OptionsParser::~OptionsParser()
{
  for (int i=0; i<ARGC; i++) { delete [] ARGV[i]; }
  delete [] ARGV; 
  ARGC = 0;
}

char * OptionsParser::ArgByIndex(int index)
{
  if (index >= ARGC) throw "*** ArgByIndex - Index out of range ***";
  return ARGV [ index ];
}

bool   OptionsParser::HasArgument(char * argname, bool casesensitive)
{
  char * Argname = new char [ strlen(argname)+1 ];
  if (casesensitive == false) 
       strcpy(Argname, tolower(argname));
  else strcpy(Argname, argname);

  for (int i=0; i<ARGC; i++)
  { 
    if ((casesensitive == false) && (strcmp(tolower(ARGV[i]), argname) == 0) ||
	((casesensitive == true)  && (strcmp(ARGV[i], argname) == 0))) 
    {
     delete [] Argname;
     return true;
    }
  }
  delete [] Argname;
  return false;
}

char * OptionsParser::ArgumentValue(char * argname, bool casesensitive, char * defaultvalue)
{
  char * Argname = new char [ strlen(argname)+1 ];
  if (casesensitive == false) 
       strcpy(Argname, tolower(argname)); 
  else strcpy(Argname, argname);
  int index = -1; 
  for (int i=0; i<ARGC; i++)
  { 
    if ((casesensitive == false) && (strcmp(tolower(ARGV[i]), argname) == 0) ||
	((casesensitive == true)  && (strcmp(ARGV[i], argname) == 0))) 
    index = i+1;
  }
  delete [] Argname;
  if (index != -1) { return ArgByIndex(index); }
  return defaultvalue;
}





