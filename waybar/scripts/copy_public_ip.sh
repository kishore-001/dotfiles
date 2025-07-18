#!/bin/bash

IPV4=$(curl -4 -s https://icanhazip.com)
IPV6=$(curl -6 -s https://icanhazip.com)

if [[ -n "$IPV4" ]]; then
  echo -n "$IPV4" | wl-copy
  notify-send "󰞉 $IPV4 Public Address Copied"
elif [[ -n "$IPV6" ]]; then
  echo -n "$IPV6" | wl-copy
  notify-send "󰞉 $IPV6 Public Address Copied"
else
  notify-send "Error While Copying The IP Address"
fi
