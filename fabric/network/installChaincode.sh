export FABRIC_CFG_PATH=$PWD/../config/

#Installing network chaincode
echo "Installing and approving on VA"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:13051
peer lifecycle chaincode package networkcc.tar.gz --path chaincode/networkcc/ --lang golang --label networkcc
peer lifecycle chaincode install networkcc.tar.gz
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "networkcc" | awk -F " " '{print $3}' | awk -F "," '{print $1}')
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --channelID orgschannel --name networkcc --version 1.0 --package-id $PACKAGE_ID --sequence 1 --collections-config ./chaincode/collections-config.json --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


echo "Installing and approving on Healthcare"
export CORE_PEER_LOCALMSPID="HealthcareMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/healthcare/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/healthcare/admin/msp
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install networkcc.tar.gz
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "networkcc" | awk -F " " '{print $3}' | awk -F "," '{print $1}')
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --channelID orgschannel --name networkcc --version 1.0 --package-id $PACKAGE_ID --sequence 1 --collections-config ./chaincode/collections-config.json --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


echo "Installing and approving on Veteran"
export CORE_PEER_LOCALMSPID="VeteranMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/veteran/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/veteran/admin/msp
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install networkcc.tar.gz
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "networkcc" | awk -F " " '{print $3}' | awk -F "," '{print $1}')
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --channelID orgschannel --name networkcc --version 1.0 --package-id $PACKAGE_ID --sequence 1 --collections-config ./chaincode/collections-config.json --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


echo "Installing and approving on Insurance"
export CORE_PEER_LOCALMSPID="InsuranceMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/insurance/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/insurance/admin/msp
export CORE_PEER_ADDRESS=localhost:11051
peer lifecycle chaincode install networkcc.tar.gz
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "networkcc" | awk -F " " '{print $3}' | awk -F "," '{print $1}')
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --channelID orgschannel --name networkcc --version 1.0 --package-id $PACKAGE_ID --sequence 1 --collections-config ./chaincode/collections-config.json --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


echo "Committing chaincode on channel"
peer lifecycle chaincode checkcommitreadiness --channelID orgschannel --name networkcc --version 1.0 --sequence 1 --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --output json
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer0-orderers --channelID orgschannel --name networkcc --version 1.0 --sequence 1 --collections-config ./chaincode/collections-config.json --tls --cafile /var/hyperledger/orderers/orderer/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses localhost:7051 --tlsRootCertFiles /var/hyperledger/healthcare/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses localhost:9051 --tlsRootCertFiles /var/hyperledger/veteran/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem --peerAddresses localhost:13051 --tlsRootCertFiles /var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

peer lifecycle chaincode querycommitted --channelID orgschannel --name networkcc --cafile /var/hyperledger/insurance/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem

#Runs the InitLedger function on the chaincode using the VAMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:13051
peer chaincode invoke -o localhost:7050 --channelID orgschannel --name networkcc -c '{"Args":["InitLedger"]}' --tls --cafile /var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
