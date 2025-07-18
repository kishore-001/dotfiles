# Get the current profile mode and extract the mode name
CURRENT_MODE=$(asusctl profile -p | awk -F 'is ' '{print $2}')

# Available modes (formatted correctly)
MODES=$(printf "Quiet\nBalanced\nPerformance")

# Display the current mode in the terminal
echo "Current Mode: $CURRENT_MODE"

# Use rofi to select a new mode
SELECTED_MODE=$(printf "%s" "$MODES" | rofi -dmenu -p "Select Mode:")

# Change the mode if a valid selection is made
if [[ -n "$SELECTED_MODE" ]]; then
  asusctl profile --profile-set "$SELECTED_MODE"
  echo "Switched to: $SELECTED_MODE"
else
  echo "No mode selected."
fi
