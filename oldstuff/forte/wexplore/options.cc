#include <string.h>
#include "options.h"

Option::Option()
{
  strcpy(name,"");
  kind = o_unknown;
  value.intval = 0; // Ecrase par la ligne suivante mais explicite
  value.strval = (char *) NULL;
}

Option:: Option(OPTIONS_MAY_BE okind,
         OPTIONS_NAME  oname,
         OPTIONS_VALUE ovalue)
{
  SetValue(okind, oname, ovalue);
}

void Option::SetValue(OPTIONS_MAY_BE okind, OPTIONS_NAME oname, OPTIONS_VALUE ovalue)
{
  switch(okind)
      {
      case o_int    : value.intval = ovalue.intval; break;
      case o_string : {
                        value.strval = new char [ strlen(ovalue.strval) + 1 ];
                        strcpy(value.strval, ovalue.strval); 
                      }
      default: kind = o_unknown;
      }
}

OPTIONS_VALUE * Option::GetValue(OPTIONS_NAME oname)
{
   return &value;  
}

Option::~Option()
{
  if (value.strval != NULL)
      {
	delete [] value.strval;
	value.strval = NULL; // Theoriquement inutile
      }
}























