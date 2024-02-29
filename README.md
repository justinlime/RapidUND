# RapidUND
A set of tools/script for rapid unification node management
![Imgur](https://imgur.com/bxtWRxx.png)
#### **Dependencies**
- jq

- wget

- curl

- xxd

## rapidund
Rapidly deploy a Unification node
#### Usage:
```
bash <(curl https://raw.githubusercontent.com/refundvalidator/RapidUND/main/rapidund)
```
#### Notes:
Script should not be run as a root user. Script expects to be run as a created user with the `$HOME` env set, and `sudo` privledges 
If you have `SELinux` active installed it may block the `und.service` file for the daemon.
Script will copy the newly created `node_key.json` and `priv_validator_key.json` into `$HOME/UNDBackup` for safekeeping.

## statesync 
Refreshes the trust height and hash of your node, and freeing any previously used storage
#### Usage:
```
bash <(curl https://raw.githubusercontent.com/refundvalidator/RapidUND/main/statesync)
```
#### Notes:
Script expects the und data dir to be located in `$HOME/.und_mainchain/data` similar to how rapidund would set up a node,
if your configuration is different your results may vary.

***If you used rapidund to set up your node, the script should work without issue***

## 4-percival
Prepares the node for upcoming upgrades, script name will change depending on the currently planned upgrade name, *Currently*, the scrip can be used with:
#### Usage:
```
bash <(curl https://raw.githubusercontent.com/refundvalidator/RapidUND/main/4-percival)
```
#### Notes:
Script expects the und cosmovisor dir to be located in `$HOME/.und_mainchain/cosmovisor` similar to how rapidund would set up a node,
if your configuration is different your results may vary

***If you used rapidund to set up your node, the script should work without issue***


