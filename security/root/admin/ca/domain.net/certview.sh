#!/bin/bash

rm -f certview.log
touch certview.log

echo "*** domain_net ***" > certview.log
openssl rsa  -in domain_net.key  -passin file:domain_net.psw -text 2>&1 >> certview.log
openssl x509 -in domain_net.cert -text 2>&1 >> certview.log

echo "*** domain_server  ***" >> certview.log
openssl rsa  -in domain_server.key  -passin file:domain_server.psw -text 2>&1 >> certview.log
openssl x509 -in domain_server.cert -text 2>&1 >> certview.log 

echo "*** domain_user ***" >> certview.log
openssl rsa  -in domain_user.key  -passin file:domain_user.psw -text 2>&1 >>certview.log
openssl x509 -in domain_user.cert -text 2>&1 >> certview.log

echo "*** server:user1  ***" >> certview.log
openssl rsa  -in user1.key  -passin file:user1.psw -text 2>&1 >>certview.log
openssl x509 -in user1.cert -text 2>&1 >> certview.log

echo "*** server:user2  ***" >> certview.log
openssl rsa  -in user2.key  -passin file:user2.psw -text 2>&1 >>certview.log
openssl x509 -in user2.cert -text 2>&1 >> certview.log



