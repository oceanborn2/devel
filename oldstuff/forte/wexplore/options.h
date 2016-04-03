// Options.h -- Gestion des options
// 

#ifndef __OPTIONS_H__
#define __OPTIONS_H__

const int MAXSTRLEN = 32;
const int MAXVALLEN = 255;

union     OPTIONS_VALUE 
{
  char * strval;  // Valeur chaine
  int  intval;    // Valeur entiere
};

typedef enum { o_unknown, o_int, o_string }  OPTIONS_MAY_BE;


typedef  char OPTIONS_NAME[MAXSTRLEN+1]; // Nom de l'option
 
class Option
{
 private:
  OPTIONS_MAY_BE kind; // Genre de l'option
  OPTIONS_VALUE value; // Valeur associee
  OPTIONS_NAME  name;  // Nom de l'option
 public:
  Option();
  Option(OPTIONS_MAY_BE okind = o_int,
         OPTIONS_NAME  oname = "noname",
         OPTIONS_VALUE ovalue = "");
  ~Option();
  
  // Accesseurs en lecture et ecriture a l'option
  void            SetValue(OPTIONS_MAY_BE okind, OPTIONS_NAME oname, OPTIONS_VALUE ovalue);
  OPTIONS_VALUE * GetValue(OPTIONS_NAME oname);

      
};

#endif




















