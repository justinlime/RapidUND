# RapidUND
#### Bash script to rapidly deploy an UND Node with StateSync/Cosmovisor as Daemon

Currently, the script is set to use UND v1.6.3 and COSMOVISOR v1.2.0

No upgrade is currently in place for the next UND version within the COSMOVISOR Files




## *!!!THIS SCRIPT WILL DESTROY THE FOLLOWING FILES IF PRESENT!!!*

-$HOME/.und_mainchain

-$HOME/temp

-$HOME/UNDBackup

-/usr/local/bin/und

-/usr/local/bin/cosmovisor

-/etc/systemd/system/und.service



## *PREREQUISITES:*

-jq

-wget



## *USAGE:*

Simply run ./undsetup.sh from your terminal

If the node is stuck endlessly on "Dialing peer address" then run the script once again.

If you have SELinux installed it may block the und.service file for the daemon, only workaround I know of is to disable SELinux in /etc/selinux/config

If you are importing a current Validator, stop both this node, and your original node, then replace the node_key.json and priv_validator_key.json in $HOME/.und_mainchain/config with your original keys, then start this new node again. If both nodes are running at the same time with the same priv_validator_key.json you will be jailed.

Script will copy node_key.json and priv_validator_key.json into $HOME/UNDBackup

Node will likely fail if running a node on the current network



