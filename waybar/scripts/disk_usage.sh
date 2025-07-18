#!/bin/bash

# Get overall disk usage of root (e.g. "15G/100G used")
USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 }')

# Get details for all mounted disks and escape newlines properly
DETAILS=$(df -h | awk 'NR>1 {printf "%-20s %s used of %s (%s)\n", $6, $3, $2, $5}' | sed ':a;N;$!ba;s/\n/\\n/g')

# Output as valid JSON
echo "{\"text\": \"$USAGE\", \"tooltip\": \"$DETAILS\"}"
