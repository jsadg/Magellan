export FABRIC_CA_LOCATION=./bin/fabric-ca-client


echo "Enroll Orderers"

# preparation
mkdir -p /var/hyperledger/orderers/orderer/assets/ca 
cp /var/hyperledger/orderers/ca/admin/msp/cacerts/0-0-0-0-7053.pem /var/hyperledger/orderers/orderer/assets/ca/orderers-ca-cert.pem

mkdir -p /var/hyperledger/orderers/orderer/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/orderers/orderer/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/orderers/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/orderers/orderer/assets/ca/orderers-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://orderer0-orderers:ordererPW@0.0.0.0:7053
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/orderers/orderer/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://orderer0-orderers:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer0-orderers --csr.hosts localhost
sleep 5

cp /var/hyperledger/orderers/orderer/tls-msp/keystore/*_sk /var/hyperledger/orderers/orderer/tls-msp/keystore/key.pem

echo "Enroll Admin"

export FABRIC_CA_CLIENT_HOME=/var/hyperledger/orderers/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/orderers/orderer/assets/ca/orderers-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://admin-orderers:orderersadminpw@0.0.0.0:7053

mkdir -p /var/hyperledger/orderers/orderer/msp/admincerts
cp /var/hyperledger/orderers/admin/msp/signcerts/cert.pem /var/hyperledger/orderers/orderer/msp/admincerts/orderers-admin-cert.pem

mkdir -p /var/hyperledger/orderers/msp/{admincerts,cacerts,tlscacerts,users}
cp /var/hyperledger/orderers/orderer/assets/ca/orderers-ca-cert.pem /var/hyperledger/orderers/msp/cacerts/
cp /var/hyperledger/orderers/orderer/assets/tls-ca/tls-ca-cert.pem /var/hyperledger/orderers/msp/tlscacerts/
cp /var/hyperledger/orderers/admin/msp/signcerts/cert.pem /var/hyperledger/orderers/msp/admincerts/admin-orderers-cert.pem
cp /var/hyperledger/orderers/admin/msp/keystore/*_sk /var/hyperledger/orderers/admin/msp/keystore/key.pem
cp ./orderers-config.yaml /var/hyperledger/orderers/msp/config.yaml
echo "Orderer done"
sleep 5
echo 


#------------------------------------------------------------------------------------------------------




echo "Enroll Peer1"

# preparation
mkdir -p /var/hyperledger/healthcare/peer1/assets/ca 
cp /var/hyperledger/healthcare/ca/admin/msp/cacerts/0-0-0-0-7054.pem /var/hyperledger/healthcare/peer1/assets/ca/healthcare-ca-cert.pem

mkdir -p /var/hyperledger/healthcare/peer1/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/healthcare/peer1/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/healthcare/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/peer1/assets/ca/healthcare-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer1-healthcare:peer1PW@0.0.0.0:7054
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/peer1/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer1-healthcare:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-healthcare --csr.hosts localhost
sleep 5

cp /var/hyperledger/healthcare/peer1/tls-msp/keystore/*_sk /var/hyperledger/healthcare/peer1/tls-msp/keystore/key.pem

echo "Enroll Peer2"

# preparation
mkdir -p /var/hyperledger/healthcare/peer2/assets/ca 
cp /var/hyperledger/healthcare/ca/admin/msp/cacerts/0-0-0-0-7054.pem /var/hyperledger/healthcare/peer2/assets/ca/healthcare-ca-cert.pem

mkdir -p /var/hyperledger/healthcare/peer2/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/healthcare/peer2/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/healthcare/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/peer2/assets/ca/healthcare-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer2-healthcare:peer2PW@0.0.0.0:7054
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/peer2/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer2-healthcare:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-healthcare --csr.hosts localhost
sleep 5

cp /var/hyperledger/healthcare/peer2/tls-msp/keystore/*_sk /var/hyperledger/healthcare/peer2/tls-msp/keystore/key.pem

echo "Enroll Admin"

export FABRIC_CA_CLIENT_HOME=/var/hyperledger/healthcare/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/healthcare/peer1/assets/ca/healthcare-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://admin-healthcare:healthcareAdminPW@0.0.0.0:7054

mkdir -p /var/hyperledger/healthcare/peer1/msp/admincerts
cp /var/hyperledger/healthcare/admin/msp/signcerts/cert.pem /var/hyperledger/healthcare/peer1/msp/admincerts/healthcare-admin-cert.pem

mkdir -p /var/hyperledger/healthcare/peer2/msp/admincerts
cp /var/hyperledger/healthcare/admin/msp/signcerts/cert.pem /var/hyperledger/healthcare/peer2/msp/admincerts/healthcare-admin-cert.pem

mkdir -p /var/hyperledger/healthcare/admin/msp/admincerts
cp /var/hyperledger/healthcare/admin/msp/signcerts/cert.pem /var/hyperledger/healthcare/admin/msp/admincerts/healthcare-admin-cert.pem

mkdir -p /var/hyperledger/healthcare/msp/{admincerts,cacerts,tlscacerts,users}
cp /var/hyperledger/healthcare/peer1/assets/ca/healthcare-ca-cert.pem /var/hyperledger/healthcare/msp/cacerts/
cp /var/hyperledger/healthcare/peer1/assets/tls-ca/tls-ca-cert.pem /var/hyperledger/healthcare/msp/tlscacerts/
cp /var/hyperledger/healthcare/admin/msp/signcerts/cert.pem /var/hyperledger/healthcare/msp/admincerts/admin-healthcare-cert.pem
cp ./healthcare-config.yaml /var/hyperledger/healthcare/msp/config.yaml
echo "Healthcare done"
sleep 5


#---------------------------------------------------------------------------------------------------------------


echo "Enroll Peer1"

# preparation
mkdir -p /var/hyperledger/veteran/peer1/assets/ca 
cp /var/hyperledger/veteran/ca/admin/msp/cacerts/0-0-0-0-7055.pem /var/hyperledger/veteran/peer1/assets/ca/veteran-ca-cert.pem

mkdir -p /var/hyperledger/veteran/peer1/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/veteran/peer1/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/veteran/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/peer1/assets/ca/veteran-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer1-veteran:peer1PW@0.0.0.0:7055
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/peer1/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer1-veteran:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-veteran --csr.hosts localhost
sleep 5

cp /var/hyperledger/veteran/peer1/tls-msp/keystore/*_sk /var/hyperledger/veteran/peer1/tls-msp/keystore/key.pem

echo "Enroll Peer2"

# preparation
mkdir -p /var/hyperledger/veteran/peer2/assets/ca 
cp /var/hyperledger/veteran/ca/admin/msp/cacerts/0-0-0-0-7055.pem /var/hyperledger/veteran/peer2/assets/ca/veteran-ca-cert.pem

mkdir -p /var/hyperledger/veteran/peer2/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/veteran/peer2/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/veteran/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/peer2/assets/ca/veteran-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer2-veteran:peer2PW@0.0.0.0:7055
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/peer2/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer2-veteran:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-veteran --csr.hosts localhost
sleep 5

cp /var/hyperledger/veteran/peer2/tls-msp/keystore/*_sk /var/hyperledger/veteran/peer2/tls-msp/keystore/key.pem

echo "Enroll Admin"

export FABRIC_CA_CLIENT_HOME=/var/hyperledger/veteran/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/veteran/peer1/assets/ca/veteran-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://admin-veteran:veteranAdminPW@0.0.0.0:7055

mkdir -p /var/hyperledger/veteran/peer1/msp/admincerts
cp /var/hyperledger/veteran/admin/msp/signcerts/cert.pem /var/hyperledger/veteran/peer1/msp/admincerts/veteran-admin-cert.pem

mkdir -p /var/hyperledger/veteran/peer2/msp/admincerts
cp /var/hyperledger/veteran/admin/msp/signcerts/cert.pem /var/hyperledger/veteran/peer2/msp/admincerts/veteran-admin-cert.pem

mkdir -p /var/hyperledger/veteran/admin/msp/admincerts
cp /var/hyperledger/veteran/admin/msp/signcerts/cert.pem /var/hyperledger/veteran/admin/msp/admincerts/veteran-admin-cert.pem

mkdir -p /var/hyperledger/veteran/msp/{admincerts,cacerts,tlscacerts,users}
cp /var/hyperledger/veteran/peer1/assets/ca/veteran-ca-cert.pem /var/hyperledger/veteran/msp/cacerts/
cp /var/hyperledger/veteran/peer1/assets/tls-ca/tls-ca-cert.pem /var/hyperledger/veteran/msp/tlscacerts/
cp /var/hyperledger/veteran/admin/msp/signcerts/cert.pem /var/hyperledger/veteran/msp/admincerts/admin-veteran-cert.pem
cp ./veteran-config.yaml /var/hyperledger/veteran/msp/config.yaml
echo "veteran done"


#------------------------------------------------------------------------------------------------------



echo "Enroll Peer1"

# preparation
mkdir -p /var/hyperledger/insurance/peer1/assets/ca 
cp /var/hyperledger/insurance/ca/admin/msp/cacerts/0-0-0-0-7056.pem /var/hyperledger/insurance/peer1/assets/ca/insurance-ca-cert.pem

mkdir -p /var/hyperledger/insurance/peer1/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/insurance/peer1/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/insurance/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/peer1/assets/ca/insurance-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer1-insurance:peer1PW@0.0.0.0:7056
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/peer1/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer1-insurance:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-insurance --csr.hosts localhost
sleep 5

cp /var/hyperledger/insurance/peer1/tls-msp/keystore/*_sk /var/hyperledger/insurance/peer1/tls-msp/keystore/key.pem

echo "Enroll Peer2"

# preparation
mkdir -p /var/hyperledger/insurance/peer2/assets/ca 
cp /var/hyperledger/insurance/ca/admin/msp/cacerts/0-0-0-0-7056.pem /var/hyperledger/insurance/peer2/assets/ca/insurance-ca-cert.pem

mkdir -p /var/hyperledger/insurance/peer2/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/insurance/peer2/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/insurance/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/peer2/assets/ca/insurance-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer2-insurance:peer2PW@0.0.0.0:7056
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/peer2/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer2-insurance:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-insurance --csr.hosts localhost
sleep 5

cp /var/hyperledger/insurance/peer2/tls-msp/keystore/*_sk /var/hyperledger/insurance/peer2/tls-msp/keystore/key.pem

echo "Enroll Admin"

export FABRIC_CA_CLIENT_HOME=/var/hyperledger/insurance/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/insurance/peer1/assets/ca/insurance-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://admin-insurance:insuranceAdminPW@0.0.0.0:7056

mkdir -p /var/hyperledger/insurance/peer1/msp/admincerts
cp /var/hyperledger/insurance/admin/msp/signcerts/cert.pem /var/hyperledger/insurance/peer1/msp/admincerts/insurance-admin-cert.pem

mkdir -p /var/hyperledger/insurance/peer2/msp/admincerts
cp /var/hyperledger/insurance/admin/msp/signcerts/cert.pem /var/hyperledger/insurance/peer2/msp/admincerts/insurance-admin-cert.pem

mkdir -p /var/hyperledger/insurance/admin/msp/admincerts
cp /var/hyperledger/insurance/admin/msp/signcerts/cert.pem /var/hyperledger/insurance/admin/msp/admincerts/insurance-admin-cert.pem

mkdir -p /var/hyperledger/insurance/msp/{admincerts,cacerts,tlscacerts,users}
cp /var/hyperledger/insurance/peer1/assets/ca/insurance-ca-cert.pem /var/hyperledger/insurance/msp/cacerts/
cp /var/hyperledger/insurance/peer1/assets/tls-ca/tls-ca-cert.pem /var/hyperledger/insurance/msp/tlscacerts/
cp /var/hyperledger/insurance/admin/msp/signcerts/cert.pem /var/hyperledger/insurance/msp/admincerts/admin-insurance-cert.pem
cp ./insurance-config.yaml /var/hyperledger/insurance/msp/config.yaml
echo "Insurance done"


#------------------------------------------------------------------------------------------------------


echo "Enroll Peer1"

# preparation
mkdir -p /var/hyperledger/va/peer1/assets/ca 
cp /var/hyperledger/va/ca/admin/msp/cacerts/0-0-0-0-7057.pem /var/hyperledger/va/peer1/assets/ca/va-ca-cert.pem

mkdir -p /var/hyperledger/va/peer1/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/va/peer1/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/va/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/peer1/assets/ca/va-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer1-va:peer1PW@0.0.0.0:7057
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/peer1/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer1-va:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-va --csr.hosts localhost
sleep 5

cp /var/hyperledger/va/peer1/tls-msp/keystore/*_sk /var/hyperledger/va/peer1/tls-msp/keystore/key.pem

echo "Enroll Peer2"

# preparation
mkdir -p /var/hyperledger/va/peer2/assets/ca 
cp /var/hyperledger/va/ca/admin/msp/cacerts/0-0-0-0-7057.pem /var/hyperledger/va/peer2/assets/ca/va-ca-cert.pem

mkdir -p /var/hyperledger/va/peer2/assets/tls-ca 
cp /var/hyperledger/tls-ca/admin/msp/cacerts/0-0-0-0-7052.pem /var/hyperledger/va/peer2/assets/tls-ca/tls-ca-cert.pem

# for identity
export FABRIC_CA_CLIENT_HOME=/var/hyperledger/va/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/peer2/assets/ca/va-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://peer2-va:peer2PW@0.0.0.0:7057
sleep 5

# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/peer2/assets/tls-ca/tls-ca-cert.pem

$FABRIC_CA_LOCATION enroll -d -u https://peer2-va:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-va --csr.hosts localhost
sleep 5

cp /var/hyperledger/va/peer2/tls-msp/keystore/*_sk /var/hyperledger/va/peer2/tls-msp/keystore/key.pem

echo "Enroll Admin"

export FABRIC_CA_CLIENT_HOME=/var/hyperledger/va/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/hyperledger/va/peer1/assets/ca/va-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp

$FABRIC_CA_LOCATION enroll -d -u https://admin-va:vaAdminPW@0.0.0.0:7057

mkdir -p /var/hyperledger/va/peer1/msp/admincerts
cp /var/hyperledger/va/admin/msp/signcerts/cert.pem /var/hyperledger/va/peer1/msp/admincerts/va-admin-cert.pem

mkdir -p /var/hyperledger/va/peer2/msp/admincerts
cp /var/hyperledger/va/admin/msp/signcerts/cert.pem /var/hyperledger/va/peer2/msp/admincerts/va-admin-cert.pem

mkdir -p /var/hyperledger/va/admin/msp/admincerts
cp /var/hyperledger/va/admin/msp/signcerts/cert.pem /var/hyperledger/va/admin/msp/admincerts/va-admin-cert.pem

mkdir -p /var/hyperledger/va/msp/{admincerts,cacerts,tlscacerts,users}
cp /var/hyperledger/va/peer1/assets/ca/va-ca-cert.pem /var/hyperledger/va/msp/cacerts/
cp /var/hyperledger/va/peer1/assets/tls-ca/tls-ca-cert.pem /var/hyperledger/va/msp/tlscacerts/
cp /var/hyperledger/va/admin/msp/signcerts/cert.pem /var/hyperledger/va/msp/admincerts/admin-va-cert.pem
cp ./va-config.yaml /var/hyperledger/va/msp/config.yaml
echo "va done"
