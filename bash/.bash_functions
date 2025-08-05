#!/bin/bash

# Python Environment Creation

ENV_DIR="$HOME/env"

av() {
  ENV_DIR="$HOME/env"

  # Check if the directory exists
  if [[ ! -d "$ENV_DIR" ]]; then
    echo "No environment directory found in $HOME/env"
    return 1
  fi

  # Get a list of environments
  ENV_LIST=$(ls "$ENV_DIR")

  if [[ -z "$ENV_LIST" ]]; then
    echo "No virtual environments found in $ENV_DIR"
    return 1
  fi

  # Use rofi to select an environment
  SELECTED_ENV=$(echo "$ENV_LIST" | rofi -dmenu -p "Select environment:" -lines 5 -width 10)

  if [[ -n "$SELECTED_ENV" ]]; then
    source "$ENV_DIR/$SELECTED_ENV/bin/activate"
    echo "Activated environment: $SELECTED_ENV"
    export CURRENT_ENV="$SELECTED_ENV"
  else
    echo "No environment selected."
  fi
}

dv() {
  if [[ -n "$CURRENT_ENV" ]]; then
    deactivate
    echo "Deactivated environment: $CURRENT_ENV"
    unset CURRENT_ENV
  else
    echo "No environment is currently active."
  fi
}

cenv() {
  # Prompt the user to enter a name for the new environment
  NEW_ENV=$(rofi -dmenu -p "Enter new environment name:" -lines 0 -width 10)

  if [[ -z "$NEW_ENV" ]]; then
    echo "No environment name entered."
    return 1
  fi

  # Create the environment directory if it doesn't exist
  mkdir -p "$ENV_DIR"

  # Check if the environment already exists
  if [[ -d "$ENV_DIR/$NEW_ENV" ]]; then
    echo "Environment '$NEW_ENV' already exists."
    return 1
  fi

  # Create a new virtual environment
  python -m venv "$ENV_DIR/$NEW_ENV"
  echo "Created new environment: $NEW_ENV"
}

denv() {
  # Get the list of environments
  ENV_DIR="$HOME/env"

  if [[ ! -d "$ENV_DIR" ]]; then
    echo "No environment directory found in $HOME/env"
    return 1
  fi

  ENV_LIST=$(ls "$ENV_DIR")
  if [[ -z "$ENV_LIST" ]]; then
    echo "No virtual environments found in $ENV_DIR"
    return 1
  fi

  # Use rofi to select an environment to delete
  SELECTED_ENV=$(echo "$ENV_LIST" | rofi -dmenu -p "Select environment to delete:" -lines 5 -width 10)

  if [[ -n "$SELECTED_ENV" ]]; then
    CONFIRM=$(echo -e "Yes\nNo" | rofi -dmenu -p "Are you sure you want to delete $SELECTED_ENV?")

    if [[ "$CONFIRM" == "Yes" ]]; then
      rm -rf "$ENV_DIR/$SELECTED_ENV"
      echo "Deleted environment: $SELECTED_ENV"
    else
      echo "Deletion cancelled."
    fi
  else
    echo "No environment selected."
  fi
}

# ASUS PROFILE MODES

pm() {
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
}

# GITHUB copilot

# Function to explain a command using GitHub Copilot
ce() {
  if [ -z "$1" ]; then
    echo "Usage: copilot_explain <command>"
  else
    gh copilot explain "$*"
  fi
}

# Function to get code suggestions using GitHub Copilot
cs() {
  if [ -z "$1" ]; then
    echo "Usage: copilot_suggest <prompt>"
  else
    gh copilot suggest "$*"
  fi
}

# Add image function

addimage() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: addimage <AppImage path>"
    return 1
  fi

  APPIMAGE_PATH="$(realpath "$1")"
  [[ ! -f "$APPIMAGE_PATH" ]] && echo "❌ File does not exist: $APPIMAGE_PATH" && return 1

  APPIMAGE_NAME="$(basename "$APPIMAGE_PATH")"
  FOLDER_NAME="${APPIMAGE_NAME%.AppImage}"
  INSTALL_DIR="$HOME/appimage/$FOLDER_NAME"
  DESKTOP_DIR="$HOME/.local/share/applications"
  mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR"

  # Prompt for display name
  read -p "📝 Enter a name for the desktop entry: " CUSTOM_NAME
  [[ -z "$CUSTOM_NAME" ]] && echo "❌ Name cannot be empty." && return 1

  # Prompt for optional custom icon path
  read -p "🎨 Enter full path to icon file (.png/.svg/.jpg) [Leave blank to auto-extract]: " CUSTOM_ICON_PATH

  # Define paths
  APPIMAGE_DEST="$INSTALL_DIR/$APPIMAGE_NAME"
  DESKTOP_FILE="$DESKTOP_DIR/${CUSTOM_NAME// /_}.desktop"
  ICON_DEST="$INSTALL_DIR/icon.png"

  echo "📦 Installing $APPIMAGE_NAME to $INSTALL_DIR..."
  cp "$APPIMAGE_PATH" "$APPIMAGE_DEST" || {
    echo "❌ Failed to move AppImage."
    return 1
  }
  chmod +x "$APPIMAGE_DEST"

  # Handle icon
  if [[ -n "$CUSTOM_ICON_PATH" && -f "$CUSTOM_ICON_PATH" ]]; then
    cp "$CUSTOM_ICON_PATH" "$ICON_DEST"
    ICON_LINE="Icon=$ICON_DEST"
    echo "✅ Using custom icon."
  else
    echo "🔍 Attempting to extract icon from AppImage..."
    cd "$INSTALL_DIR"
    "$APPIMAGE_DEST" --appimage-extract &>/dev/null

    FOUND_ICON=$(find squashfs-root -type f \( -iname '*.png' -o -iname '*.svg' -o -iname '*.jpg' \) | grep -i icon | head -n 1)

    if [[ -n "$FOUND_ICON" && -f "$FOUND_ICON" ]]; then
      cp "$FOUND_ICON" "$ICON_DEST"
      ICON_LINE="Icon=$ICON_DEST"
      echo "✅ Extracted icon: $(basename "$FOUND_ICON")"
    else
      ICON_LINE="Icon=application-default-icon"
      echo "⚠️ No icon found in AppImage. Using system default."
    fi

    rm -rf squashfs-root
  fi

  # Create .desktop entry
  echo "🧩 Creating desktop entry..."
  cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=$CUSTOM_NAME
Exec=$APPIMAGE_DEST
$ICON_LINE
Comment=Installed via addimage
Terminal=false
Categories=Utility;
EOF

  chmod +x "$DESKTOP_FILE"
  echo "✅ '$CUSTOM_NAME' successfully added to your application launcher."
}

removeimage() {
  DESKTOP_DIR="$HOME/.local/share/applications"
  APP_DIR="$HOME/appimage"

  # List .desktop files added via addimage
  ENTRIES=$(grep -l "Installed via addimage" "$DESKTOP_DIR"/*.desktop 2>/dev/null | xargs -n1 basename | sed 's/\.desktop$//')

  if [[ -z "$ENTRIES" ]]; then
    echo "❌ No apps installed via addimage found."
    return 1
  fi

  # Let user select which one to remove
  SELECTED=$(echo "$ENTRIES" | rofi -dmenu -p "Select app to remove:" -lines 5 -width 30)

  [[ -z "$SELECTED" ]] && echo "❌ No selection made. Aborted." && return 1

  DESKTOP_FILE="$DESKTOP_DIR/$SELECTED.desktop"
  FOLDER_NAME=$(awk -F '=' '/Exec=/{print $2}' "$DESKTOP_FILE" | xargs dirname)

  echo "🧹 Preparing to remove:"
  echo "  ❯ Folder: $FOLDER_NAME"
  echo "  ❯ Entry:  $DESKTOP_FILE"

  # Confirm
  CONFIRM=$(echo -e "Yes\nNo" | rofi -dmenu -p "Delete $SELECTED?")
  [[ "$CONFIRM" != "Yes" ]] && echo "🛑 Cancelled." && return 1

  # Remove both
  rm -rf "$FOLDER_NAME" && echo "✅ Removed: $FOLDER_NAME"
  rm -f "$DESKTOP_FILE" && echo "✅ Removed: $DESKTOP_FILE"

  echo "✅ '$SELECTED' successfully uninstalled."
}
