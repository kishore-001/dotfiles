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
