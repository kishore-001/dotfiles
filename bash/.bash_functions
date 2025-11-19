#!/bin/bash

# ──────────────────────────────────────────────────────────────
# 🧠 Universal Bash Utility Script
#  Includes: Python Env Manager | AppImage Manager | Asus Profile | Tmux Manager | Misc Tools
#  Author: Ghost
#  Location: ~/.bash_functions
# ──────────────────────────────────────────────────────────────

# ──────────────────────────────────────────────────────────────
# 🐍 PYTHON VIRTUAL ENVIRONMENT MANAGER
# ──────────────────────────────────────────────────────────────

ENV_DIR="$HOME/env"

# ▶️ Activate Virtual Environment
av() {
  if [[ ! -d "$ENV_DIR" ]]; then
    echo "❌ No environment directory found in $ENV_DIR"
    return 1
  fi

  ENV_LIST=$(find "$ENV_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)
  [[ -z "$ENV_LIST" ]] && echo "❌ No virtual environments found." && return 1

  SELECTED_ENV=$(echo "$ENV_LIST" | rofi -dmenu -p "Select environment:" -lines 5 -width 10)
  [[ -z "$SELECTED_ENV" ]] && echo "⚠️ No environment selected." && return 1

  source "$ENV_DIR/$SELECTED_ENV/bin/activate"
  export CURRENT_ENV="$SELECTED_ENV"
  echo "✅ Activated environment: $SELECTED_ENV"
}

# ⏹️ Deactivate Current Virtual Environment
dv() {
  if [[ -n "$CURRENT_ENV" ]]; then
    deactivate
    echo "🧹 Deactivated environment: $CURRENT_ENV"
    unset CURRENT_ENV
  else
    echo "⚠️ No environment is currently active."
  fi
}

# 🧪 Create New Environment
cenv() {
  NEW_ENV=$(rofi -dmenu -p "Enter new environment name:" -lines 0 -width 10)
  [[ -z "$NEW_ENV" ]] && echo "❌ No name entered." && return 1

  mkdir -p "$ENV_DIR"
  [[ -d "$ENV_DIR/$NEW_ENV" ]] && echo "⚠️ Environment '$NEW_ENV' already exists." && return 1

  python -m venv "$ENV_DIR/$NEW_ENV"
  echo "✅ Created new environment: $NEW_ENV"
}

# 🗑️ Delete Existing Environment
denv() {
  [[ ! -d "$ENV_DIR" ]] && echo "❌ No environment directory found." && return 1
  ENV_LIST=$(find "$ENV_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)
  [[ -z "$ENV_LIST" ]] && echo "❌ No environments found." && return 1

  SELECTED_ENV=$(echo "$ENV_LIST" | rofi -dmenu -p "Select environment to delete:" -lines 5 -width 10)
  [[ -z "$SELECTED_ENV" ]] && echo "⚠️ No selection made." && return 1

  CONFIRM=$(echo -e "Yes\nNo" | rofi -dmenu -p "Delete $SELECTED_ENV?")
  [[ "$CONFIRM" != "Yes" ]] && echo "🛑 Cancelled." && return 1

  rm -rf "$ENV_DIR/$SELECTED_ENV"
  echo "✅ Deleted environment: $SELECTED_ENV"
}

# ──────────────────────────────────────────────────────────────
# ⚙️ ASUS PROFILE MANAGER
# ──────────────────────────────────────────────────────────────
pm() {
  CURRENT_MODE=$(asusctl profile -p | awk -F 'is ' '{print $2}')
  MODES="Quiet\nBalanced\nPerformance"
  echo "💻 Current Mode: $CURRENT_MODE"
  SELECTED_MODE=$(printf "$MODES" | rofi -dmenu -p "Select Mode:")
  [[ -z "$SELECTED_MODE" ]] && echo "⚠️ No mode selected." && return

  asusctl profile --profile-set "$SELECTED_MODE"
  echo "✅ Switched to: $SELECTED_MODE"
}

# ──────────────────────────────────────────────────────────────
# 📦 APPIMAGE INSTALLER & REMOVER
# ──────────────────────────────────────────────────────────────

addimage() {
  [[ $# -ne 1 ]] && echo "Usage: addimage <AppImage path>" && return 1
  APPIMAGE_PATH="$(realpath "$1")"
  [[ ! -f "$APPIMAGE_PATH" ]] && echo "❌ File does not exist: $APPIMAGE_PATH" && return 1

  APPIMAGE_NAME="$(basename "$APPIMAGE_PATH")"
  FOLDER_NAME="${APPIMAGE_NAME%.AppImage}"
  INSTALL_DIR="$HOME/appimage/$FOLDER_NAME"
  DESKTOP_DIR="$HOME/.local/share/applications"
  mkdir -p "$INSTALL_DIR" "$DESKTOP_DIR"

  read -p "📝 App Name: " CUSTOM_NAME
  [[ -z "$CUSTOM_NAME" ]] && echo "❌ Name cannot be empty." && return 1

  read -p "🎨 Icon Path (.png/.svg/.jpg) [optional]: " CUSTOM_ICON_PATH
  APPIMAGE_DEST="$INSTALL_DIR/$APPIMAGE_NAME"
  DESKTOP_FILE="$DESKTOP_DIR/${CUSTOM_NAME// /_}.desktop"
  ICON_DEST="$INSTALL_DIR/icon.png"

  echo "📦 Installing $APPIMAGE_NAME..."
  cp "$APPIMAGE_PATH" "$APPIMAGE_DEST" && chmod +x "$APPIMAGE_DEST"

  if [[ -n "$CUSTOM_ICON_PATH" && -f "$CUSTOM_ICON_PATH" ]]; then
    cp "$CUSTOM_ICON_PATH" "$ICON_DEST"
    ICON_LINE="Icon=$ICON_DEST"
  else
    echo "🔍 Extracting icon..."
    cd "$INSTALL_DIR" && "$APPIMAGE_DEST" --appimage-extract &>/dev/null
    FOUND_ICON=$(find squashfs-root -type f \( -iname '*.png' -o -iname '*.svg' -o -iname '*.jpg' \) | grep -i icon | head -n 1)
    if [[ -n "$FOUND_ICON" ]]; then
      cp "$FOUND_ICON" "$ICON_DEST"; ICON_LINE="Icon=$ICON_DEST"
    else
      ICON_LINE="Icon=application-default-icon"
    fi
    rm -rf squashfs-root
  fi

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
  echo "✅ '$CUSTOM_NAME' added to your launcher."
}

removeimage() {
  DESKTOP_DIR="$HOME/.local/share/applications"
  APP_DIR="$HOME/appimage"
  ENTRIES=$(grep -l "Installed via addimage" "$DESKTOP_DIR"/*.desktop 2>/dev/null | xargs -n1 basename | sed 's/\.desktop$//')
  [[ -z "$ENTRIES" ]] && echo "❌ No addimage apps found." && return 1

  SELECTED=$(echo "$ENTRIES" | rofi -dmenu -p "Select app to remove:" -lines 5)
  [[ -z "$SELECTED" ]] && echo "🛑 Cancelled." && return 1

  DESKTOP_FILE="$DESKTOP_DIR/$SELECTED.desktop"
  FOLDER_NAME=$(awk -F '=' '/Exec=/{print $2}' "$DESKTOP_FILE" | xargs dirname)
  CONFIRM=$(echo -e "Yes\nNo" | rofi -dmenu -p "Delete $SELECTED?")
  [[ "$CONFIRM" != "Yes" ]] && echo "🛑 Cancelled." && return 1

  rm -rf "$FOLDER_NAME" "$DESKTOP_FILE"
  echo "✅ '$SELECTED' removed."
}

# ──────────────────────────────────────────────────────────────
# 🌍 QUICK SERVE (PYTHON HTTP)
# ──────────────────────────────────────────────────────────────
serve() {
  local dir=${1:-$(pwd)}
  local port=${2:-2210}
  [[ ! -d "$dir" ]] && echo "❌ Directory not found: $dir" && return 1
  echo "🚀 Serving $dir at http://localhost:$port"
  (cd "$dir" && python3 -m http.server "$port")
}

# ──────────────────────────────────────────────────────────────
# 🧾 FUZZY COMMAND HISTORY
# ──────────────────────────────────────────────────────────────
h() {
  history -a
  local cmd
  cmd=$(history | tail -n 200 | tac | awk '{$1=""; print substr($0,2)}' | fzf --reverse --height 50%)
  [[ -n "$cmd" ]] && eval "$cmd"
}

# ──────────────────────────────────────────────────────────────
# 🔳 TMUX SESSION MANAGER
# ──────────────────────────────────────────────────────────────

# Create or attach session for current directory
tn() {
  local dir="$PWD"
  local base_name session_name i=1
  base_name="$(basename "$(dirname "$dir")")-$(basename "$dir" | sed 's/[^a-zA-Z0-9_-]/_/g')"
  session_name="$base_name"
  while tmux has-session -t "$session_name" 2>/dev/null; do
    session_name="${base_name}_$i"; ((i++))
  done
  tmux new-session -d -s "$session_name" -c "$dir"
  echo "✅ Created tmux session: $session_name in $dir"
  [[ -n "$TMUX" ]] && tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
}

# Create or attach session from zoxide
tc() {
  local dir
  dir=$(zoxide query -l 2>/dev/null | fzf --prompt="📂 Pick frequent directory: ") || true
  [[ -z "$dir" ]] && echo "❌ No frequent directories found." && return

  local base_name session_name i=1
  base_name="$(basename "$(dirname "$dir")")-$(basename "$dir" | sed 's/[^a-zA-Z0-9_-]/_/g')"
  session_name="$base_name"
  while tmux has-session -t "$session_name" 2>/dev/null; do
    session_name="${base_name}_$i"; ((i++))
  done
  tmux new-session -d -s "$session_name" -c "$dir"
  echo "✅ Created tmux session: $session_name in $dir"
  [[ -n "$TMUX" ]] && tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
}

# Attach to an existing tmux session
a() {
  local session
  session=$(tmux ls 2>/dev/null | fzf --prompt="Attach to session: ") || return
  local session_name
  session_name=$(echo "$session" | awk -F: '{print $1}')
  [[ -n "$TMUX" ]] && tmux switch-client -t "$session_name" || tmux attach-session -t "$session_name"
}

# Detach from current session
xx() { tmux detach; }

# List all tmux sessions (beautiful)
tl() {
  if ! tmux has-session 2>/dev/null; then
    echo -e "\033[38;5;111mNo active tmux sessions.\033[0m"
    return
  fi
  local BLUE="\033[38;5;110m" CYAN="\033[38;5;81m" GRAY="\033[38;5;240m" RESET="\033[0m"
  echo -e "${GRAY}─────────────────────────────────────────────────${RESET}"
  tmux list-sessions | while IFS= read -r line; do
    local name windows date_raw formatted_time
    name=$(echo "$line" | awk -F: '{print $1}')
    windows=$(echo "$line" | grep -o '[0-9]\+ windows')
    date_raw=$(echo "$line" | sed -E 's/.*\(created (.*)\)/\1/')
    formatted_time=$(date -d "$date_raw" +"%I:%M %p %b %d" 2>/dev/null || echo "$date_raw")
    printf "${BLUE}%-18s${RESET} ${CYAN}%-12s${RESET} ${GRAY}%s${RESET}\n" "$name" "$windows" "$formatted_time"
  done
  echo -e "${GRAY}─────────────────────────────────────────────────${RESET}"
}

# cd + tmux auto session



cdd() {
    local INCLUDE_HIDDEN="^\.config$|^\.local$" dir session_name
    local SEARCH_BASE="$HOME"

    # Pick directory using fd or find + fzf
    if command -v fd >/dev/null 2>&1; then
        dir=$(fd --type d --hidden --max-depth 3 . "$SEARCH_BASE" 2>/dev/null \
            | grep -E "($INCLUDE_HIDDEN)|^[^\.]" \
            | fzf --prompt="📁 Choose directory: " \
                  --preview='exa --tree -L 1 --color=always {} 2>/dev/null' \
                  --preview-window=right:50%)
    else
        dir=$(find "$SEARCH_BASE" -type d 2>/dev/null \
            | sed "s|^$SEARCH_BASE/||" \
            | grep -E "($INCLUDE_HIDDEN)|^[^\.]" \
            | fzf --prompt="📁 Choose directory: " \
                  --preview='exa --tree -L 1 --color=always {} 2>/dev/null' \
                  --preview-window=right:50%)
    fi

    [[ -z "$dir" ]] && return

    # Move to chosen directory
    cd "$dir" || return
    echo "📂 Moved to: $(pwd)"

    # Ask user if they want to create a tmux session
    read -rp "Do you want to create/attach a tmux session here? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        # Get last two words of PWD for session name
        local parts=(${PWD//\// })
        if [ ${#parts[@]} -ge 2 ]; then
            session_name="${parts[-2]}-${parts[-1]}"
        else
            session_name="${parts[-1]}"
        fi

        if tmux has-session -t "$session_name" 2>/dev/null; then
            echo "🔁 Attaching to existing session: $session_name"
        else
            echo "🚀 Creating new tmux session: $session_name"
            tmux new-session -d -s "$session_name" -c "$PWD"
        fi

        tmux attach-session -t "$session_name"
    fi
}
# ──────────────────────────────────────────────────────────────
# 🏁 END OF SCRIPT
# ──────────────────────────────────────────────────────────────
