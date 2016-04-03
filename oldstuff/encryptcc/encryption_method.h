#ifndef __ENCRYPTION_METHOD_H__
#define __ENCRYPTION_METHOD_H__

#include "buffer.h"

class EncryptionMethod 
{
 public:
  EncryptionMethod();
 ~EncryptionMethod();
  virtual char * getname();
  virtual void encrypt(PBUFFER buffer, char * key) = 0;
  virtual void decrypt(PBUFFER buffer, char * key) = 0;
};

#endif
