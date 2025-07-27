#!/bin/bash

set -e

# Get absolute path to this script's directory
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📁 Setting up dotfiles from: $dotfiles_dir"
mkdir -p "$HOME/.config"

# Function to create symlinks with backup & conflict handling
create_symlink() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "⚠️  Conflict: $dest exists and is not a symlink."

    # Prompt backup
    backup="${dest}.backup_$(date +%s)"
    echo "🔁 Backing up existing file/dir to $backup"
    mv "$dest" "$backup"
  elif [ -L "$dest" ]; then
    # Existing symlink, force update
    echo "🔗 Updating existing symlink: $dest"
    rm -f "$dest"
  fi

  ln -sf "$src" "$dest"
  echo "✅ Linked: $dest → $src"
}

# === Bash configs ===
create_symlink "$dotfiles_dir/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$dotfiles_dir/bash/.bash_alias" "$HOME/.bash_alias"
create_symlink "$dotfiles_dir/bash/.bash_functions" "$HOME/.bash_functions"

# === App configs ===
create_symlink "$dotfiles_dir/kitty" "$HOME/.config/kitty"
create_symlink "$dotfiles_dir/rofi" "$HOME/.config/rofi"
create_symlink "$dotfiles_dir/waybar" "$HOME/.config/waybar"
create_symlink "$dotfiles_dir/fastfetch" "$HOME/.config/fastfetch"
create_symlink "$dotfiles_dir/nvim" "$HOME/.config/nvim"
create_symlink "$dotfiles_dir/mako" "$HOME/.config/mako" # NEW: mako config
create_symlink "$dotfiles_dir/lsd" "$HOME/.config/lsd"

# === Optional: more tools can be added here ===
# create_symlink "$dotfiles_dir/zsh/.zshrc" "$HOME/.zshrc"

echo -e "\n🎉 All dotfiles linked successfully."

# Reload shell if bash
if [[ "$SHELL" == *"bash"* ]]; then
  echo "🔄 Reloading Bash..."
  exec bash
fi
