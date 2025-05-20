echo "Registering tls-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/tls-ca/crypto/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/tls-ca/admin
export FABRIC_CA_LOCATION=./bin/fabric-ca-client

$FABRIC_CA_LOCATION enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052 --csr.hosts localhost
sleep 5

$FABRIC_CA_LOCATION register -d --id.name peer1-healthcare --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer2-healthcare --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer1-veteran --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer2-veteran --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer1-insurance --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer2-insurance --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer1-va --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name peer2-va --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
$FABRIC_CA_LOCATION register -d --id.name orderer0-orderers --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052


echo "Registering orderers-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/orderers/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/orderers/ca/admin

$FABRIC_CA_LOCATION enroll -d -u https://orderers-ca-admin:orderers-ca-adminpw@0.0.0.0:7053 --csr.hosts localhost
sleep 5

$FABRIC_CA_LOCATION register -d --id.name orderer0-orderers --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7053
$FABRIC_CA_LOCATION register -d --id.name admin-orderers --id.secret orderersadminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053

echo "Registering healthcare-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/healthcare/ca/admin

$FABRIC_CA_LOCATION enroll -d -u https://healthcare-ca-admin:healthcare-ca-adminpw@0.0.0.0:7054
sleep 5

$FABRIC_CA_LOCATION register -d --id.name peer1-healthcare --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
$FABRIC_CA_LOCATION register -d --id.name peer2-healthcare --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
$FABRIC_CA_LOCATION register -d --id.name admin-healthcare --id.secret healthcareAdminPW --id.type admin -u https://0.0.0.0:7054
$FABRIC_CA_LOCATION register -d --id.name user-healthcare --id.secret healthcareUserPW --id.type user -u https://0.0.0.0:7054

echo "Working on veteran-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/veteran/ca/admin

$FABRIC_CA_LOCATION enroll -d -u https://veteran-ca-admin:veteran-ca-adminpw@0.0.0.0:7055
sleep 5

$FABRIC_CA_LOCATION register -d --id.name peer1-veteran --id.secret peer1PW --id.type peer -u https://0.0.0.0:7055
$FABRIC_CA_LOCATION register -d --id.name peer2-veteran --id.secret peer2PW --id.type peer -u https://0.0.0.0:7055
$FABRIC_CA_LOCATION register -d --id.name admin-veteran --id.secret veteranAdminPW --id.type admin -u https://0.0.0.0:7055
$FABRIC_CA_LOCATION register -d --id.name user-veteran --id.secret veteranUserPW --id.type user -u https://0.0.0.0:7055


echo "Working on insurance-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/insurance/ca/admin

$FABRIC_CA_LOCATION enroll -d -u https://insurance-ca-admin:insurance-ca-adminpw@0.0.0.0:7056
sleep 5

$FABRIC_CA_LOCATION register -d --id.name peer1-insurance --id.secret peer1PW --id.type peer -u https://0.0.0.0:7056
$FABRIC_CA_LOCATION register -d --id.name peer2-insurance --id.secret peer2PW --id.type peer -u https://0.0.0.0:7056
$FABRIC_CA_LOCATION register -d --id.name admin-insurance --id.secret insuranceAdminPW --id.type admin -u https://0.0.0.0:7056
$FABRIC_CA_LOCATION register -d --id.name user-insurance --id.secret insuranceUserPW --id.type user -u https://0.0.0.0:7056


echo "Working on va-ca"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/va/ca/admin

$FABRIC_CA_LOCATION enroll -d -u https://va-ca-admin:va-ca-adminpw@0.0.0.0:7057
sleep 5

$FABRIC_CA_LOCATION register -d --id.name peer1-va --id.secret peer1PW --id.type peer -u https://0.0.0.0:7057
$FABRIC_CA_LOCATION register -d --id.name peer2-va --id.secret peer2PW --id.type peer -u https://0.0.0.0:7057
$FABRIC_CA_LOCATION register -d --id.name admin-va --id.secret vaAdminPW --id.type admin -u https://0.0.0.0:7057
$FABRIC_CA_LOCATION register -d --id.name user-va --id.secret vaUserPW --id.type user -u https://0.0.0.0:7057

echo "DONE"
