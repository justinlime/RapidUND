# RapidUND
#### Bash script to rapidly deploy an Unification Node with StateSync/Cosmovisor as Daemon

Script has been tested with CentOS and Debian, but should work with similar distributions without issue.

A video demonstration can be found here:
https://youtu.be/nAh_VgSNyY0

## *PREREQUISITES:*
```
-jq

-wget

-curl
```

## *USAGE:*

To install and run, just use: 
```
bash <(curl https://raw.githubusercontent.com/refundvalidator/RapidUND/main/rapidund)
```

If the node is stuck "Dialing peer address" for more than 10 minutes, then run the script once again.

If you have `SELinux` active installed it may block the `und.service` file for the daemon.

If you are importing a current Validator, stop both this node, and your original node, then replace the `node_key.json` and `priv_validator_key.json` in `$HOME/.und_mainchain/config` with your original keys, then start this new node again. 

If both nodes are running at the same time, with the same keys, your Validator will be JAILED.

Script will copy `node_key.json` and `priv_validator_key.json` into `$HOME/UNDBackup` for safekeeping.

## *DETAILS:*

The node deployed will be using default configuration given by the Unification Docs at https://docs.unification.io/.

This script is meant to be used by experienced operators, used to quickly deploy a node in a time of need or when migrating to another machine, this is not recommended if you have not yet set up a node on your own.



