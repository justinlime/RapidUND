#!/bin/bash
GENESIS=https://raw.githubusercontent.com/unification-com/mainnet/master/latest/genesis.json
UND=https://github.com/unification-com/mainchain/releases/download/v1.6.3/und_v1.6.3_linux_x86_64.tar.gz
COSMOVISOR=https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz
SEEDS=0c2b65bc604a18a490f5f55bb7b4140cfb512ced@seed1.unification.io:26656,e66e0f89af19da09f676c85b262d591b8c2bb9d8@seed2.unification.io:26656
RPC=sync1.unification.io:26657,sync2.unification.io:26657
HANDH=$(curl -s https://rest.unification.io/blocks/latest | jq '.|[.block_id.hash,.block.header.height]')

remove_und() {
	sudo systemctl daemon-reload
	sudo systemctl stop und
	sudo systemctl disable und
	sudo rm -r $HOME/.und_mainchain
	sudo rm -r $HOME/tempund
	sudo rm -r $HOME/UNDBackup
	sudo rm -r /usr/local/bin/und
	sudo rm -r /usr/local/bin/cosmovisor
	sudo rm -r /etc/systemd/system/und.service
}

echo "

      ___          ___          ___                   ___         ___          ___          ___     
     /\  \        /\  \        /\  \        ___      /\  \       /\__\        /\__\        /\  \    
    /::\  \      /::\  \      /::\  \      /\  \    /::\  \     /:/  /       /::|  |      /::\  \   
   /:/\:\  \    /:/\:\  \    /:/\:\  \     \:\  \  /:/\:\  \   /:/  /       /:|:|  |     /:/\:\  \  
  /::\~\:\  \  /::\~\:\  \  /::\~\:\  \    /::\__\/:/  \:\__\ /:/  /  ___  /:/|:|  |__  /:/  \:\__\ 
 /:/\:\ \:\__\/:/\:\ \:\__\/:/\:\ \:\__\__/:/\/__/:/__/ \:|__/:/__/  /\__\/:/ |:| /\__\/:/__/ \:|__|
 \/_|::\/:/  /\/__\:\/:/  /\/__\:\/:/  /\/:/  /  \:\  \ /:/  |:\  \ /:/  /\/__|:|/:/  /\:\  \ /:/  /
    |:|::/  /      \::/  /      \::/  /\::/__/    \:\  /:/  / \:\  /:/  /     |:/:/  /  \:\  /:/  / 
    |:|\/__/       /:/  /        \/__/  \:\__\     \:\/:/  /   \:\/:/  /      |::/  /    \:\/:/  /  
    |:|  |        /:/  /                 \/__/      \::/__/     \::/  /       /:/  /      \::/__/   
     \|__|        \/__/                              ~~          \/__/        \/__/        ~~       

"

echo -e "\nThis script is made to rapidly deploy a Unification Node, for Testnet or Mainnet, intended for expirienced operators.\n\nIf there are any issues please report them on github.\n"

while true;
do
read -p "Install, or Remove the node?[i/r]> " CHOOSE
if [ "$CHOOSE" = "i" ];
then
     break
fi
if [ "$CHOOSE" = "r" ];
then
	while true;
	do
	echo -e "\n!!!CAUTION!!!\n\nThis option will DESTROY the following files if present: \n\n$HOME/.und_mainchain\n$HOME/tempund\n$HOME/UNDBackup\n/usr/local/bin/und\n/usr/local/bin/cosmovisor\n/etc/systemd/system/und.service\n"
	read -p "Do you wish to continue?[y/n]> " CONTINUE
	if [ "$CONTINUE" = "y" ];
	then
		remove_und
		echo -e "\nAll Unification files removed\n"
        exit
    fi
    if [ "$CONTINUE" = "n" ];
    then
	echo -e "\nExiting\n"
		exit
    fi        
    done
fi
done 

echo -e "\n!!!CAUTION!!!\n\nThis script will DESTROY the following files if present: \n\n$HOME/.und_mainchain\n$HOME/tempund\n$HOME/UNDBackup\n/usr/local/bin/und\n/usr/local/bin/cosmovisor\n/etc/systemd/system/und.service\n"

while true;
do
read -p "Do you wish to continue?[y/n]> " CONTINUE
if [ "$CONTINUE" = "n" ];
then
	echo -e "\nExiting\n"
	exit
fi
if [ "$CONTINUE" = "y" ];
then
	break
fi
done

while true;
do
read -p "Would you like to set up for Testnet, or Mainnet?[t/m]> " TEST_MAIN
if [ "$TEST_MAIN" = "t" ];
then
    GENESIS=https://raw.githubusercontent.com/unification-com/testnet/master/latest/genesis.json
    UND=https://github.com/unification-com/mainchain/releases/download/v1.6.3/und_v1.6.3_linux_x86_64.tar.gz
    COSMOVISOR=https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz
    SEEDS=e428c5653865da4a55f5599d7ff3203789abadfd@seed-testnet.unification.io:26656
    RPC=sync1-testnet.unification.io:26657,sync2-testnet.unification.io:26657
    HANDH=$(curl -s https://rest-testnet.unification.io/blocks/latest | jq '.|[.block_id.hash,.block.header.height]')
    break
fi
if [ "$TEST_MAIN" = "m" ];
then
	break
fi
done

read -p "Input node moniker/name> " MONIKER

#Removing old directories and files
remove_und

#Making new working directories
mkdir $HOME/UNDBackup
mkdir -p $HOME/tempund/und
mkdir $HOME/tempund/cosmovisor

#Setting up UND
wget $UND -P $HOME/tempund/und
tar -zxvf $HOME/tempund/und/$(ls $HOME/tempund/und) -C $HOME/tempund/und
sudo cp $HOME/tempund/und/und /usr/local/bin
und init $MONIKER
curl $GENESIS > $HOME/.und_mainchain/config/genesis.json
cp $HOME/.und_mainchain/config/priv_validator_key.json $HOME/UNDBackup
cp $HOME/.und_mainchain/config/node_key.json $HOME/UNDBackup
sudo tee /etc/systemd/system/und.service > /dev/null <<EOF
[Unit] 
Description=Unification Mainchain Node 
 
[Service] 
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$HOME
EnvironmentFile=$HOME/.und_mainchain/cosmovisor/UND_COSMOVISOR_ENV
ExecStart=/usr/local/bin/cosmovisor run start
Restart=on-failure
RestartSec=10s
LimitNOFILE=4096 
 
[Install] 
WantedBy=default.target
EOF


#Setting up Cosmovisor
wget $COSMOVISOR -P $HOME/tempund/cosmovisor
tar -zxvf $HOME/tempund/cosmovisor/$(ls $HOME/tempund/cosmovisor) -C $HOME/tempund/cosmovisor
mkdir -p $HOME/.und_mainchain/cosmovisor/genesis/bin
mkdir $HOME/.und_mainchain/cosmovisor/upgrades
mv $HOME/tempund/und/und $HOME/.und_mainchain/cosmovisor/genesis/bin
sudo mv $HOME/tempund/cosmovisor/cosmovisor /usr/local/bin
tee $HOME/.und_mainchain/cosmovisor/UND_COSMOVISOR_ENV > /dev/null <<EOF
DAEMON_NAME=und
DAEMON_HOME=$HOME/.und_mainchain
DAEMON_RESTART_AFTER_UPGRADE=true
DAEMON_RESTART_DELAY=5s
EOF

#Editing configs
HASH="${HANDH:4:66}"
HEIGHT="${HANDH:75:7}"
sed -i "s/enable = false/enable = true/" $HOME/.und_mainchain/config/config.toml
sed -i "s/trust_height = 0/trust_height = $HEIGHT/" $HOME/.und_mainchain/config/config.toml
sed -i 's/trust_hash = ""/trust_hash = '"$HASH"'/' $HOME/.und_mainchain/config/config.toml
sed -i 's/rpc_servers = ""/rpc_servers = "'$RPC'"/' $HOME/.und_mainchain/config/config.toml
sed -i 's/discovery_time = "15s"/discovery_time = "30s"/' $HOME/.und_mainchain/config/config.toml
sed -i 's/chunk_request_timeout = "10s"/chunk_request_timeout = "60s"/' $HOME/.und_mainchain/config/config.toml
sed -i 's/seeds = ""/seeds = "'$SEEDS'"/' $HOME/.und_mainchain/config/config.toml



#Cleanup
rm -r $HOME/tempund

#TO DO: SELinux Fix


#Startup
sudo systemctl daemon-reload
sudo systemctl enable und
sudo systemctl start und
sudo journalctl -u und -f

