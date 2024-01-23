#!/bin/bash

# Banner
wget -qO- https://pastebin.com/raw/QNjeBUjs | sed -e 's/<[^>]*>//g'

echo -e "\n"

# Get user input for BEVM node wallet address
read -p "Enter your BEVM node wallet address: " node_wallet_address

# Update and upgrade system
sudo apt-get update
sudo apt-get upgrade -y

# Install BEVM
mkdir -p $HOME/.bevm
wget -O bevm https://github.com/btclayer2/BEVM/releases/download/testnet-v0.1.1/bevm-v0.1.1-ubuntu20.04 && chmod +x bevm
sudo cp bevm /usr/bin/
bevm --version

# Configure BEVM as a systemd service
sudo tee /etc/systemd/system/bevm.service > /dev/null << EOF
[Unit]
Description=BEVM Node
After=network-online.target
StartLimitIntervalSec=0

[Service]
User=$USER
Restart=always
RestartSec=3
ExecStart=/usr/bin/bevm \
  --base-path $HOME/.bevm/data/validator/$node_wallet_address \
  --name $node_wallet_address \
  --chain testnet \
  --telemetry-url "wss://telemetry.bevm.io/submit 0" \
  --bootnodes="/ip4/84.247.170.13/tcp/30333/ws/p2p/12D3KooWL1VtfpTyqLsWpxYi6HVfNAHUjqyiXfLG2hwCf6BHtgUR"

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd configurations
sudo systemctl daemon-reload

# Enable and start the BEVM service
sudo systemctl enable bevm
sudo systemctl start bevm

# Monitor BEVM logs
sudo journalctl -u bevm -f --no-hostname -o cat
