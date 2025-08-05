#!/bin/bash

# Get supported modes (clean formatting)
modes=$(supergfxctl --supported 2>/dev/null | tr -d '[],')

# Let user select mode via rofi
chosen=$(echo "$modes" | tr ' ' '\n' | rofi -dmenu -p "Select GPU Mode:")

# Exit if nothing chosen
[[ -z "$chosen" ]] && exit 0

# Try to set mode and capture both stdout + stderr
output=$(supergfxctl --mode "$chosen" 2>&1)

# Check for success/reboot required
if echo "$output" | grep -qi "A reboot is required"; then
  notify-send -a "GPU Switcher" -u normal "✅ Mode set to $chosen" "🔄 A reboot is required to apply changes."
elif [[ $? -eq 0 ]]; then
  notify-send -a "GPU Switcher" -u normal "✅ GPU mode switched to $chosen"
else
  # Error case
  notify-send -a "GPU Switcher" -u critical "❌ Failed to switch GPU mode" "$output"
fi
