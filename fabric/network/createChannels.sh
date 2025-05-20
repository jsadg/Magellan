export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:13051

#Orgs Channel
sleep 2
peer channel create -o localhost:7050 -c orgschannel -f /var/hyperledger/channel-artifacts/orgschannel/orgschannel.tx --outputBlock /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block --ordererTLSHostnameOverride orderer0-orderers --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block
peer channel update -c orgschannel -f /var/hyperledger/channel-artifacts/orgschannel/vaMSPanchors.tx -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer2/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:14051
peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block

#Joining Healthcare Org
export CORE_PEER_LOCALMSPID="HealthcareMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/healthcare/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/healthcare/admin/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block
peer channel update -c orgschannel -f /var/hyperledger/channel-artifacts/orgschannel/healthcareMSPanchors.tx -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

export CORE_PEER_LOCALMSPID="HealthcareMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/healthcare/peer2/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/healthcare/admin/msp
export CORE_PEER_ADDRESS=localhost:8051
peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block

sleep 2
#Joining Veteran Org
export CORE_PEER_LOCALMSPID="VeteranMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/veteran/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/veteran/admin/msp
export CORE_PEER_ADDRESS=localhost:9051

peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block
peer channel update -c orgschannel -f /var/hyperledger/channel-artifacts/orgschannel/veteranMSPanchors.tx -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

sleep 2

export CORE_PEER_LOCALMSPID="VeteranMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/veteran/peer2/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/veteran/admin/msp
export CORE_PEER_ADDRESS=localhost:10051
peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block


sleep 2
#Joining Insurance Org
export CORE_PEER_LOCALMSPID="InsuranceMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/insurance/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/insurance/admin/msp
export CORE_PEER_ADDRESS=localhost:11051

peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block
peer channel update -c orgschannel -f /var/hyperledger/channel-artifacts/orgschannel/insuranceMSPanchors.tx -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

sleep 2

export CORE_PEER_LOCALMSPID="InsuranceMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/insurance/peer2/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/insurance/admin/msp
export CORE_PEER_ADDRESS=localhost:12051
peer channel join -b /var/hyperledger/channel-artifacts/orgschannel/orgschannel.block
