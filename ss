#!/bin/bash
sudo systemctl stop und

rm -rf $HOME/.und_mainchain/data/*
rm -rf $HOME/.und_mainchain/addrbook.json
tee $HOME/.und_mainchain/data/priv_validator_state.json > /dev/null <<EOF
{
  "height": "0",
  "round": 0,
  "step": 0
}
EOF

HANDH_URL=https://rest.unification.io/blocks/latest
HANDH=$(curl -s $HANDH_URL | jq '.|[.block_id.hash,.block.header.height]')
HASH="${HANDH:4:66}"
HEIGHT="${HANDH:75:7}"
sed -i "s/trust_height.*/trust_height = $HEIGHT/" $HOME/.und_mainchain/config/config.toml
sed -i 's/trust_hash.*/trust_hash = '"$HASH"'/' $HOME/.und_mainchain/config/config.toml

sudo systemctl restart und
sudo journalctl -u und -f -o cat
