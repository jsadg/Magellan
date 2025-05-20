export FABRIC_CFG_PATH=../config
configtxgen -profile OrgsOrdererGenesis -outputBlock /var/hyperledger/channel-artifacts/genesis.block -channelID systemchannel
configtxgen -profile OrgsChannel -outputCreateChannelTx /var/hyperledger/channel-artifacts/orgschannel/orgschannel.tx -channelID orgschannel
export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:13051
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/hyperledger/channel-artifacts/orgschannel/vaMSPanchors.tx -channelID orgschannel -asOrg VAMSP
export CORE_PEER_LOCALMSPID="HealthcareMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/healthcare/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/healthcare/admin/msp
export CORE_PEER_ADDRESS=localhost:7051
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/hyperledger/channel-artifacts/orgschannel/healthcareMSPanchors.tx -channelID orgschannel -asOrg HealthcareMSP
export CORE_PEER_LOCALMSPID="VeteranMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/veteran/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/veteran/admin/msp
export CORE_PEER_ADDRESS=localhost:9051
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/hyperledger/channel-artifacts/orgschannel/veteranMSPanchors.tx -channelID orgschannel -asOrg VeteranMSP
export CORE_PEER_LOCALMSPID="InsuranceMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/insurance/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/insurance/admin/msp
export CORE_PEER_ADDRESS=localhost:11051
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/hyperledger/channel-artifacts/orgschannel/insuranceMSPanchors.tx -channelID orgschannel -asOrg InsuranceMSP

