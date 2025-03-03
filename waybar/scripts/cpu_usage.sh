#!/bin/bash

# Get CPU usage
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')

# Get CPU temperature (for most systems using hwmon)
cpu_temp=$(sensors | awk '/Core 0/ {print $3}' | tr -d '+°C')

# If temp not found, try another method
if [[ -z "$cpu_temp" ]]; then
    cpu_temp=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | awk '{print $1/1000 "°C"}' | head -n 1)
fi

# Output formatted CPU info
echo " $cpu_usage | $cpu_temp"

