#!/bin/bash
PACMAN=$(checkupdates 2>/dev/null | wc -l)
AUR=$(yay -Qum 2>/dev/null | wc -l)
TOTAL=$((PACMAN + AUR))
TOOLTIP=$( (
  checkupdates 2>/dev/null
  echo
  yay -Qum 2>/dev/null
) | head -n 30)
[[ -z "$TOOLTIP" ]] && TOOLTIP="No pending updates."
echo "{\"text\": \"󰏔 $TOTAL\", \"tooltip\": \"Pending Updates: $TOTAL\n\n$TOOLTIP\"}"
