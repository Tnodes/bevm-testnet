#!/bin/bash

# Banner
wget -qO- https://pastebin.com/raw/QNjeBUjs | sed -e 's/<[^>]*>//g'

echo -e "\n"

# Get user input for EVM address
read -p "Enter your EVM address: " evm_address

# Update and upgrade system
sudo apt-get update
sudo apt-get upgrade

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Create storage directory
sudo mkdir -p /var/lib/node_bevm_test_storage

# Pull BEVM Docker image
sudo docker pull btclayer2/bevm:v0.1.1

# Run BEVM Docker container with user input
sudo docker run -d -v /var/lib/node_bevm_test_storage:/root/.local/share/bevm btclayer2/bevm:v0.1.1 bevm \
  "--chain=testnet" \
  "--name=$evm_address" \
  "--pruning=archive" \
  --telemetry-url "wss://telemetry.bevm.io/submit 0" \
  --bootnodes "/ip4/84.247.170.13/tcp/30333/ws/p2p/12D3KooWL1VtfpTyqLsWpxYi6HVfNAHUjqyiXfLG2hwCf6BHtgUR"

# Check logs
echo -e "check logs use command:"
echo -e "sudo docker logs -f <output>"
