#ifndef __OPTIONS_PARSER_H__
#define __OPTIONS_PARSER_H__

class OptionsParser
{
 private:
  int     ARGC;
  char ** ARGV;
 public:
  OptionsParser() { throw "*** not supported ***"; }
  OptionsParser(int ARGC, char * ARGV[]);
 ~OptionsParser();
  virtual char * ArgByIndex(int index); 
  virtual bool   HasArgument  (char * argname, bool casesensitive=false);
  virtual char * ArgumentValue(char * argname, bool casesensitive=false, 
                               char * defaultvalue=0);
};

#endif
