#!/bin/bash
GENESIS=https://raw.githubusercontent.com/unification-com/mainnet/master/latest/genesis.json
GENESIS_UND=https://github.com/unification-com/mainchain/releases/download/1.5.1/und_v1.5.1_linux_x86_64.tar.gz
TAR_UND=und_v1.6.3_linux_x86_64.tar.gz
UND=https://github.com/unification-com/mainchain/releases/download/v1.6.3/und_v1.6.3_linux_x86_64.tar.gz
COSMOVISOR=https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz
TAR_COSMOVISOR=cosmovisor-v1.2.0-linux-amd64.tar.gz
# echo -e "\nScript is setup to use UND v1.6.3 as daemon with cosmovisor installed"
# echo "Script assumes you are using Debian or RHEL based instance"
# echo -e "\n!!!CAUTION!!! Script will destroy .und_mainchain in the $HOME directory and und in /usr/local/bin do you wish to continue?> [y] or [n]\n"
# read -p "Is your OS Debian based or RHEL based?> [d] or [c] " distro
# read -p "Are you importing a validator?> [y] or [n]" import
# read -p "Select pruning option> [default][nothing][custom]" pruning
read -p "Input node moniker> " MONIKER

sudo rm -r $HOME/.und_mainchain
sudo rm -r $HOME/temp
sudo rm -r $HOME/UNDBackup
sudo rm -r /usr/local/bin/und
sudo rm -r /etc/systemd/system/und.service

mkdir $HOME/temp
mkdir $HOME/temp/und
mkdir $HOME/temp/genesis_und
mkdir $HOME/UNDBackup

wget $UND
mv $TAR_UND $HOME/temp
tar -zxvf $HOME/temp/$TAR_UND -C $HOME/temp
sudo mv $HOME/temp/und /usr/local/bin
und init $MONIKER
curl $GENESIS > $HOME/.und_mainchain/config/genesis.json
#sed -i 's/trust_height = 0/trust_height = 200/' config.toml
