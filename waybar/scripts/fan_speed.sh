#!/bin/bash

cpu_fan=$(cat /sys/class/hwmon/hwmon*/fan1_input 2>/dev/null)
gpu_fan=$(cat /sys/class/hwmon/hwmon*/fan2_input 2>/dev/null)

if [[ -z "$cpu_fan" ]]; then
    cpu_fan="N/A"
fi

if [[ -z "$gpu_fan" ]]; then
    gpu_fan="N/A"
fi

echo "󰈐 CPU: ${cpu_fan} RPM | GPU: ${gpu_fan} RPM"

