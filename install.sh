#!/bin/bash

# Get the directory of the script
dotfiles_dir="$(pwd)"

echo "Setting up dotfiles from $dotfiles_dir..."

# Ensure necessary directories exist
mkdir -p "$HOME/.config"

# Function to create symlinks with conflict checking
create_symlink() {
  src="$1"
  dest="$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "⚠️  Skipped: $dest already exists and is not a symlink."
    echo "   To apply the dotfiles correctly, either:"
    echo "     - Rename or back up the existing file: mv \"$dest\" \"${dest}.backup\""
    echo "     - Or remove it: rm -rf \"$dest\""
    echo
    return 1
  fi

  ln -sf "$src" "$dest"
}

# Bash configs
create_symlink "$dotfiles_dir/bash/.bashrc" "$HOME/.bashrc"
create_symlink "$dotfiles_dir/bash/.bash_functions" "$HOME/.bash_functions"
create_symlink "$dotfiles_dir/bash/.bash_alias" "$HOME/.bash_alias"

# App configs
create_symlink "$dotfiles_dir/kitty" "$HOME/.config/kitty"
create_symlink "$dotfiles_dir/rofi" "$HOME/.config/rofi"
create_symlink "$dotfiles_dir/waybar" "$HOME/.config/waybar"
create_symlink "$dotfiles_dir/fastfetch" "$HOME/.config/fastfetch"
create_symlink "$dotfiles_dir/nvim" "$HOME/.config/nvim"

echo "✅ Dotfiles linking complete!"

# Reload shell if bashrc was modified and shell is bash
if [[ "$SHELL" == *"bash"* ]]; then
  echo "Reloading bash..."
  exec bash
fi
