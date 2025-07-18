#!/bin/bash
VPN_IF=$(ip -o link | awk -F': ' '/tun|wg|vpn/ {print $2}' | head -n1)
if [[ -n "$VPN_IF" ]]; then
  VPN_IP=$(ip addr show "$VPN_IF" | awk '/inet / {print $2}' | cut -d/ -f1)
  echo "{\"text\": \"󰖂 VPN\", \"tooltip\": \"VPN Interface: $VPN_IF\nIP: $VPN_IP\"}"
else
  echo '{"text": "󰖃 No VPN", "tooltip": "VPN not active"}'
fi
