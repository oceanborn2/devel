#!/bin/bash

rm -f *.key
rm -f *.csr
rm -f *.cert
rm -f *.psw
rm -f *.pub

# server passwords
ROOTPSW="ROOTPSW"
SERVERPSW="SERVERPSW"
SERVER1PSW="SERVER1PSW"
SERVER2PSW="SERVER2PSW"

# user password
USER1PSW="USER1PSW"
USER2PSW="USER2PSW"

# creation des fichiers de mots de passe
echo $ROOTPSW    > domain_net.psw
echo $SERVERPSW  > domain_server.psw
echo $SERVER1PSW > server1.psw
echo $SERVER2PSW > server2.psw
echo $USER1PSW   > user1.psw
echo $USER2PSW   > user2.psw


# vidage des fichiers series
rm -f domain_net.srl
rm -f domain_server.srl
rm -f domain_user.srl

function generate() 
{
rkey=$1
rpass=$2
rconfig=$3
rca=$4
rpassca=$5
rsubj=$6
csubj=''

if [[ (${rsubj}'x' != 'x')]]
then
  #csubj="-extensions subjectAltName=$rsubj"
  csubj="-subj \"$rsubj\""
  echo "csubj: $csubj"
  echo "rsubj: $rsubj"
fi

echo "KEY:$rkey PASS:$rpass CONFIG:$rconfig CA:$rca CApass:$rpassca"
openssl genrsa                   -out $rkey.key -passout pass:$rpass -des3 2048           -config $rconfig.cnf
openssl rsa -in $rkey.key -pubout > $rkey.pub -passin pass:$rpass 
openssl req -new -key $rkey.key  -out $rkey.csr -passout pass:$rpass -passin  pass:$rpass  -subj "${rsubj}" -config $rconfig.cnf  

if [[ $rkey == $rca ]]; then
  echo "generating the root authority self signed certificate"
  openssl x509 -trustout -req -days 365  -in $rkey.csr -passin pass:$rpass -signkey $rkey.key -passin pass:$rpass -out $rkey.cert 
else
  echo "signing with a parent authority"
  openssl x509           -req -days 365 -in $rkey.csr -passin pass:$rpass -CA $rca.cert -CAkey $rca.key -CAcreateserial -CAserial $rca.srl -passin pass:$rpassca -out $rkey.cert
  openssl rsa -in ${rkey}.key -passin pass:$rpass -out ${rkey}_un.key
fi
echo
echo ---------------------------------------------------------------------------
echo
}

generate domain_net    $ROOTPSW    rootca   domain_net $ROOTPSW
generate domain_server $SERVERPSW  serverca domain_net $ROOTPSW
generate domain_user   $USERPSW    userca   domain_net $ROOTPSW

generate server1       $SERVER1PSW server1  domain_server $SERVERPSW "/C=FR/ST=IDF/L=Paris_75000/O=domain/OU=server/CN=server1"
generate server2       $SERVER2PSW server2  domain_server $SERVERPSW "/C=FR/ST=IDF/L=Paris_75000/O=domain/OU=server/CN=server2"
generate user1        $USER1PSW   userca   domain_user   $USERPSW   "/C=FR/ST=IDF/L=Paris_75000/O=domain/OU=user/CN=User1"
generate user1        $USER1PSW   userca   domain_user   $USERPSW   "/C=FR/ST=IDF/L=Paris_75000/O=domain/OU=user/CN=User1"

cat domain_server.cert domain_net.cert  > CAServerCerts.cert
cat domain_user.cert domain_net.cert > CAUserCerts.cert

cat server1.cert CAServerCerts.cert > server1CA.cert
cat server2.cert CAServerCerts.cert > server2CA.cert

chown root:root *.key *.cert *.psw *.pub
chmod 400       *.key *.cert *.psw *.pub

# copy to apache configuration folder
cp *.cert /etc/httpd/conf
cp *.key  /etc/httpd/conf
cp *.psw  /etc/httpd/conf
cp *.pub  /srv/http/public/keys

cd /etc/httpd/conf
chown http:http *.key *.cert *.psw *.pub
chmod 400       *.key *.cert *.psw *.pub
cd -

rm *.csr

systemctl stop httpd
systemctl start httpd

