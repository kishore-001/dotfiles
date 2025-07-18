#!/bin/bash

# Set locale for predictable output
export LANG=C

# Get active network interface
interface=$(ip route | awk '/default/ {print $5}' | head -n 1)

# Get IPv4 address of that interface
ipv4=$(ip -4 addr show "$interface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)

# Build tooltip with interface names and IPs (one per line)
tooltip=$(ip -4 addr show | awk '
  /[0-9]+: / {iface=$2; gsub(":", "", iface)}
  /inet / {print iface ": " $2}
')

# Choose icon based on interface type
if [[ -z "$ipv4" ]]; then
  icon="󰖪"
  text="No IP"
else
  if [[ "$interface" =~ ^e ]]; then
    icon="󰈀"
  else
    icon=""
  fi
  text="$ipv4"
fi

# Output JSON for Waybar (escaped tooltip for newlines)
echo "{\"text\": \"$icon  $text\", \"tooltip\": \"$(echo "$tooltip" | sed ':a;N;$!ba;s/\n/\\n/g')\"}"
