#!/bin/bash

# Get active network interface
interface=$(ip route | awk '/default/ {print $5}' | head -n 1)

# Get IPv4 address
ipv4=$(ip -4 addr show "$interface" | awk '/inet / {print $2}' | cut -d/ -f1)

# Check if it's Wi-Fi or Ethernet
if [[ -z "$ipv4" ]]; then
    echo "󰖪  No IP"
else
    if [[ "$interface" =~ ^e ]]; then
        echo "󰈀  $ipv4"  # Ethernet icon
    else
        echo "  $ipv4"  # Wi-Fi icon
    fi
fi

