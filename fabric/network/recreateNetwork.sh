docker-compose down
sudo rm *.tar.gz
sudo rm -r /var/hyperledger
echo "y" | docker volume prune
sleep 5
docker-compose up -d tls-ca orderers-ca healthcare-ca insurance-ca va-ca veteran-ca
sleep 5
sudo chown -R jsadg /var/hyperledger/*
bash allReg.sh
sleep 5
bash enrollAllOrg.sh
sleep 5
sudo mkdir -p /var/hyperledger/channel-artifacts
sudo chown -R jsadg /var/hyperledger/*
sleep 5
bash createChannelArtifacts.sh
sleep 5
docker-compose up -d
sleep 5
bash createChannels.sh
sleep 5
bash installChaincode.sh
rm networkcc.tar.gz

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="VAMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/var/hyperledger/va/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/va/admin/msp
export CORE_PEER_ADDRESS=localhost:13051
export CORE_PEER_CHANNEL_ID=orsgchannel
