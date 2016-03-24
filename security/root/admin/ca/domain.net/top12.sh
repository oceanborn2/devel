#!/bin/bash

USER=$1
echo "user:$USER"

openssl pkcs12 -export -in $USER.cert -inkey $USER.key -out $USER.p12 -password file:$USER.psw
# -passout file:$USER.psw -passin file:$USER.psw  

#openssl pkcs12 -export -in $USER.cert -inkey $USER.key -out $USER.p12 
#gpgsm --import $USER.p12

