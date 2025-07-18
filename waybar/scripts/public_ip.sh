#!/bin/bash
IPV4=$(curl -4 -s https://icanhazip.com)
IPV6=$(curl -6 -s https://icanhazip.com)
if [[ -n "$IPV4" ]]; then
  DISPLAY="$IPV4"
elif [[ -n "$IPV6" ]]; then
  DISPLAY="$IPV6"
else
  DISPLAY="Unavailable"
fi
echo "{\"text\": \"󰞉 $DISPLAY\", \"tooltip\": \"IPv4: $IPV4\nIPv6: $IPV6\"}"
