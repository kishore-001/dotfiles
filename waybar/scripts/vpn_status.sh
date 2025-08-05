#!/bin/bash

# Find VPN interface (tun, wg, or vpn keyword)
VPN_IF=$(ip -o link | awk -F': ' '/tun|wg|vpn/ {print $2}' | head -n1)

# If VPN interface exists
if [[ -n "$VPN_IF" ]]; then
  VPN_IP=$(ip -4 addr show "$VPN_IF" | awk '/inet / {print $2}' | cut -d/ -f1)

  # Handle click event
  if [[ "$1" == "click" ]]; then
    if [[ -n "$VPN_IP" ]]; then
      echo -n "$VPN_IP" | wl-copy
      notify-send "VPN IP Copied" "$VPN_IP"
    fi
    exit 0
  fi

  # Output JSON for Waybar
  echo "{\"text\": \"󰖂 $VPN_IP\", \"tooltip\": \"Interface: $VPN_IF\nIP: $VPN_IP\"}"
else
  echo '{"text": "󰖃 NO VPN", "tooltip": "VPN not active"}'
fi
