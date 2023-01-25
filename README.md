# RapidUND
#### Bash script to rapidly deploy an Unification Node with StateSync/Cosmovisor as Daemon

Currently, the script is set to use UND `v1.6.3` and COSMOVISOR `v1.2.0`

No upgrade is currently in place for the next UND version within the COSMOVISOR Files.

Currently the TestNet option of the script is not functional, as statesync in not working properly on the TestNet.

Script has been tested with CentOS and Debian, but should work with similar distributions without issue.

A video demonstration can be found here:
https://youtu.be/nAh_VgSNyY0

## *!!!THIS SCRIPT WILL DESTROY THE FOLLOWING FILES IF PRESENT!!!*
```
-$HOME/.und_mainchain

-$HOME/tempund

-$HOME/UNDBackup

-/usr/local/bin/und

-/usr/local/bin/cosmovisor

-/etc/systemd/system/und.service
```


## *PREREQUISITES:*
```
-jq

-wget

-curl
```

## *USAGE:*

Simply run 
```
sh /path/to/RapidUND/rapidund
```

If the node is stuck "Dialing peer address" for more than 10 minutes, then run the script once again.

If you have `SELinux` active installed it may block the `und.service` file for the daemon.

If you are importing a current Validator, stop both this node, and your original node, then replace the `node_key.json` and `priv_validator_key.json` in `$HOME/.und_mainchain/config` with your original keys, then start this new node again. 

If both nodes are running at the same time, with the same keys, your Validator will be JAILED.

Script will copy `node_key.json` and `priv_validator_key.json` into `$HOME/UNDBackup` for safekeeping.

## *DETAILS:*

The node deployed will be using default configuration given by the Unification Docs at https://docs.unification.io/.

Pruning remains as default, this can be edited in `$HOME/.und_mainchain/config/app.toml`

This script is meant to be used by experienced operators, used to quickly deploy a node in a time of need or when migrating to another machine, this is not recommended if you have not yet set up a node on your own.



