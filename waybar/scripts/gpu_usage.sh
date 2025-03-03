#!/bin/bash
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

echo "󰢮 ${usage}% | ${temp}°C"

