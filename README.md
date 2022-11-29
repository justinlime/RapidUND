# RapidUND
Bash script to rapidly deploy an UND Node with StateSync/Cosmovisor as Daemon

Currently, the script is set to use UND v1.6.3 and COSMOVISOR v1.2.0

No upgrade is currently in place for the next UND version within the COSMOVISOR Files




*!!!THIS SCRIPT WILL DESTROY THE FOLLOWING FILES IF PRESENT!!!*

-$HOME/.und_mainchain

-$HOME/temp

-$HOME/UNDBackup

-/usr/local/bin/und

-/usr/local/bin/cosmovisor

-/etc/systemd/system/und.service

*USAGE:*

Simply run ./undsetup.sh from your terminal

If the node is stuck on "Dialing peer address" then run the script once again.



