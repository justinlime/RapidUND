#!/bin/bash
GENESIS=https://raw.githubusercontent.com/unification-com/mainnet/master/latest/genesis.json
GENESIS_UND=https://github.com/unification-com/mainchain/releases/download/1.5.1/und_v1.5.1_linux_x86_64.tar.gz
UND=https://github.com/unification-com/mainchain/releases/download/v1.6.3/und_v1.6.3_linux_x86_64.tar.gz
COSMOVISOR=https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz
CURRENT_USER=$(whoami)

# echo -e "\n!!!CAUTION!!! Script will destroy .und_mainchain in the $HOME directory and und in /usr/local/bin do you wish to continue?> [y] or [n]\n"
read -p "Input node moniker> " MONIKER

#Removing old directories and files
sudo rm -r $HOME/.und_mainchain
sudo rm -r $HOME/temp
sudo rm -r $HOME/UNDBackup
sudo rm -r /usr/local/bin/und
sudo rm -r /usr/local/bin/cosmovisor
sudo rm -r /etc/systemd/system/und.service

#Making new working directories
mkdir $HOME/UNDBackup
mkdir $HOME/temp
mkdir $HOME/temp/main_und
mkdir $HOME/temp/genesis_und
mkdir $HOME/temp/cosmovisor

#Setting up UND
wget $UND -P $HOME/temp/main_und
TAR_UND=$(ls $HOME/temp/main_und)
tar -zxvf $HOME/temp/main_und/$TAR_UND -C $HOME/temp/main_und
sudo mv $HOME/temp/main_und/und /usr/local/bin
und init $MONIKER
curl $GENESIS > $HOME/.und_mainchain/config/genesis.json
cp $HOME/.und_mainchain/config/priv_validator_key.json $HOME/UNDBackup
cp $HOME/.und_mainchain/config/node_key.json $HOME/UNDBackup
sudo tee /etc/systemd/system/und.service > /dev/null <<EOF
[Unit] 
Description=Unification Mainchain Node 
 
[Service] 
User=$CURRENT_USER
Group=$CURRENT_USER
WorkingDirectory=/home/$CURRENT_USER
EnvironmentFile=/home/$CURRENT_USER/.und_mainchain/cosmovisor/UND_COSMOVISOR_ENV
ExecStart=/usr/local/bin/cosmovisor run start
Restart=on-failure
RestartSec=10s
LimitNOFILE=4096 
 
[Install] 
WantedBy=default.target
EOF


#Setting up Cosmovisor
wget $COSMOVISOR -P $HOME/temp/cosmovisor
wget $GENESIS_UND -P $HOME/temp/genesis_und
TAR_GENESIS_UND=$(ls $HOME/temp/genesis_und)
TAR_COSMOVISOR=$(ls $HOME/temp/cosmovisor)
tar -zxvf $HOME/temp/genesis_und/$TAR_GENESIS_UND -C $HOME/temp/genesis_und
tar -zxvf $HOME/temp/cosmovisor/$TAR_COSMOVISOR -C $HOME/temp/cosmovisor
mkdir -p $HOME/.und_mainchain/cosmovisor/genesis/bin
mkdir $HOME/.und_mainchain/cosmovisor/upgrades
mv $HOME/temp/genesis_und/und $HOME/.und_mainchain/cosmovisor/genesis/bin
sudo mv $HOME/temp/cosmovisor/cosmovisor /usr/local/bin
tee $HOME/.und_mainchain/cosmovisor/UND_COSMOVISOR_ENV > /dev/null <<EOF
DAEMON_NAME=und
DAEMON_HOME=/home/$CURRENT_USER/.und_mainchain
DAEMON_RESTART_AFTER_UPGRADE=true
DAEMON_RESTART_DELAY=5s
EOF


#Editing configs
HANDH=$(curl -s https://rest.unification.io/blocks/latest | jq '.|[.block_id.hash,.block.header.height]')
HASH="${HANDH:4:66}"
HEIGHT="${HANDH:75:7}"
sed -i 's/discovery_time = "15s"/discovery_time = "30s"/g' $HOME/.und_mainchain/config/config.toml
# sed -i "s/enable = false/enable = true" $HOME/.und_mainchain/config/config.toml
# sed -i "s/enable = false/enable = true" $HOME/.und_mainchain/config/config.toml
sed -i "s/trust_height = 0/trust_height = $HEIGHT/" $HOME/.und_mainchain/config/config.toml
# sed -i "s/trust_hash = 0/trust_hash = $HASH/" $HOME/.und_mainchain/config/config.toml