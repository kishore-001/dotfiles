#!/bin/bash

activate_venv() {
  if [ -z "$1" ]; then
    echo "Usage: activate_venv <venv_folder>"
    return 1
  fi

  VENV_PATH="$1/bin/activate"

  if [ -f "$VENV_PATH" ]; then
    source "$VENV_PATH"
    echo "Activated virtual environment: $1"
  else
    echo "Error: Virtual environment '$1' not found."
    return 1
  fi
}
