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
  ENV_LIST=$(find "$ENV_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

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

  ENV_LIST=$(find "$ENV_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)
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

# Add this to ~/.bashrc or source it in your shell
serve() {
  local dir=${1:-$(pwd)} # default to current directory if no arg
  local port=${2:-2210}  # default port 2210 if not specified

  if [ ! -d "$dir" ]; then
    echo "[!] Directory '$dir' does not exist."
    return 1
  fi

  echo "[*] Serving directory '$dir' on port $port ..."
  cd "$dir" || return 1
  # Start Python3 HTTP server
  python3 -m http.server "$port"
}

h() {
  history -a # make sure current session is saved
  local cmd
  cmd=$(history | tail -n 200 | tac | awk '{$1=""; print substr($0,2)}' | fzf --reverse --height 50%)
  [ -n "$cmd" ] && eval "$cmd"
}


# TMUX MANAGER



# Create or attach a session for the current directory
tn() {
    dir="$PWD"

    # Generate a safe base name (no dots, spaces, etc.)
    base_name="$(basename "$(dirname "$dir")")-$(basename "$dir" | sed 's/[^a-zA-Z0-9_-]/_/g')"
    session_name="$base_name"

    # Ensure the session name is unique (add _1, _2, etc.)
    i=1
    while tmux has-session -t "$session_name" 2>/dev/null; do
        session_name="${base_name}_$i"
        ((i++))
    done

    # Create a new detached session
    tmux new-session -d -s "$session_name" -c "$dir"
    echo "✅ Created tmux session: $session_name in $dir"

    # Attach (or switch if already inside tmux)
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}


# Create or attach a session from a frequent zoxide directory
tc() {
    dir=$(zoxide query -l | fzf --prompt="📂 Pick frequent directory: ")
    [ -z "$dir" ] && echo "❌ No directory selected." && return

    # Clean and safe session name (no dots or slashes)
    base_name="$(basename "$(dirname "$dir")")-$(basename "$dir")"
    base_name="$(echo "$base_name" | sed 's/[^a-zA-Z0-9_-]/_/g')"

    session_name="$base_name"

    # Ensure uniqueness
    i=1
    while tmux has-session -t "$session_name" 2>/dev/null; do
        session_name="${base_name}_$i"
        ((i++))
    done

    # Create new session safely
    tmux new-session -d -s "$session_name" -c "$dir"
    echo "✅ Created tmux session: $session_name in $dir"

    # Attach (or switch if inside tmux)
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}


# Attach to an existing session (via fzf)
a() {
    session=$(tmux ls 2>/dev/null | fzf --prompt="Attach to session: ")
    [ -z "$session" ] && return
    session_name=$(echo "$session" | awk -F: '{print $1}')

    # If inside tmux, switch client; otherwise attach normally
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

xx() {
    tmux detach
}



tl() {
    # If there are no sessions
    if ! tmux has-session 2>/dev/null; then
        echo -e "\033[38;5;111mNo active tmux sessions.\033[0m"
        return
    fi

    # Color theme (dark blue aesthetic)
    local BLUE="\033[38;5;110m"
    local CYAN="\033[38;5;81m"
    local GRAY="\033[38;5;240m"
    local RESET="\033[0m"

    echo -e "${GRAY}─────────────────────────────────────────────────${RESET}"

    tmux list-sessions | while IFS= read -r line; do
        # Example: home-k1sh0rx: 1 windows (created Mon Oct 13 17:57:26 2025)
        local name windows date_raw formatted_time

        name=$(echo "$line" | awk -F: '{print $1}')
        windows=$(echo "$line" | grep -o '[0-9]\+ windows')
        date_raw=$(echo "$line" | sed -E 's/.*\(created (.*)\)/\1/')

        # Convert "Mon Oct 13 17:57:26 2025" → readable 12-hour format
        formatted_time=$(date -d "$date_raw" +"%I:%M %p %b %d" 2>/dev/null || echo "$date_raw")

        # Print aligned output
        printf "${BLUE}%-18s${RESET} ${CYAN}%-12s${RESET} ${GRAY}%s${RESET}\n" \
            "$name" "$windows" "$formatted_time"
    done

    echo -e "${GRAY}─────────────────────────────────────────────────${RESET}"
}



cdd() {
    # Define hidden dirs you want to include
    INCLUDE_HIDDEN="^\.config$|^\.local$"

    # Use fd if available
    if command -v fd >/dev/null 2>&1; then
        dir=$(fd --type d --hidden --max-depth 3 . 2>/dev/null \
              | grep -E "($INCLUDE_HIDDEN)|^[^\.]" \
              | fzf --prompt="📁 Choose directory: " \
                    --preview='exa --tree -L 1 --color=always {} 2>/dev/null' \
                    --preview-window=right:50%)
    else
        # fallback to find
        dir=$(find . -type d 2>/dev/null \
              | sed 's|^\./||' \
              | grep -E "($INCLUDE_HIDDEN)|^[^\.]" \
              | fzf --prompt="📁 Choose directory: " \
                    --preview='exa --tree -L 1 --color=always {} 2>/dev/null' \
                    --preview-window=right:50%)
    fi

    # exit if no selection
    [ -z "$dir" ] && return

    # move to directory
    cd "$dir" || return
    echo "📂 Moved to: $(pwd)"

    # Automatically generate tmux session name
    # Replace / with - and remove leading ./ for readability
    session_name=$(echo "$PWD" | sed 's|/|-|g; s|^-||')

    # create or attach
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "🔁 Attaching to existing session: $session_name"
    else
        echo "🚀 Creating new tmux session: $session_name"
        tmux new-session -d -s "$session_name" -c "$PWD"
    fi

    tmux attach-session -t "$session_name"
}

