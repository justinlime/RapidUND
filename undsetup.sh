#!/bin/bash
# echo -e "\nScript is setup to use UND v1.6.3 as daemon with cosmovisor installed"
# echo "Script assumes you are using Debian or RHEL based instance"
# echo -e "\n!!!CAUTION!!! Script will destroy .und_mainchain in the $HOME directory and und in /usr/local/bin do you wish to continue?> [y] or [n]\n"
# read -p "Is your OS Debian based or RHEL based?> [d] or [c] " distro
# read -p "Are you importing a validator?> [y] or [n]" import
# read -p "Select pruning option> [default][nothing][custom]" pruning
read -p "Input node moniker> " moniker

sudo rm -r $HOME/.und_mainchain
sudo rm -r und_v1.6.3_linux_x86_64.tar.gz
sudo rm -r /usr/local/bin/und

wget https://github.com/unification-com/mainchain/releases/download/v1.6.3/und_v1.6.3_linux_x86_64.tar.gz
tar -zxvf und_v1.6.3_linux_x86_64.tar.gz
sudo mv und /usr/local/bin/und
und init $moniker
curl https://raw.githubusercontent.com/unification-com/mainnet/master/latest/genesis.json > $HOME/.und_mainchain/config/genesis.json
