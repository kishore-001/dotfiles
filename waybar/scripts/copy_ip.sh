#!/bin/bash

# Get default interface IP and copy it
interface=$(ip route | awk '/default/ {print $5}' | head -n 1)
ipv4=$(ip -4 addr show "$interface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)

if [[ -n "$ipv4" ]]; then
  echo -n "$ipv4" | wl-copy
  notify-send "🌐 IP Copied" "$ipv4"
else
  notify-send " Error While Copying The IP "
fi
