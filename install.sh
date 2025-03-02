#!/bin/bash

# Get the directory of the script
dotfiles_dir="$(pwd)"

echo "Setting up dotfiles from $dotfiles_dir..."

# Ensure necessary directories exist
mkdir -p "$HOME/.config"

# Create symlinks
ln -sf "$dotfiles_dir/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$dotfiles_dir/kitty" "$HOME/.config/kitty"
ln -sf "$dotfiles_dir/rofi" "$HOME/.config/rofi"
ln -sf "$dotfiles_dir/waybar" "$HOME/.config/waybar"
ln -sf "$dotfiles_dir/fastfetch" "$HOME/.config/fastfetch"

echo "Dotfiles successfully linked!"

# Reload shell if bashrc was modified
if [[ "$SHELL" == *"bash"* ]]; then
    echo "Reloading bash..."
    exec bash
fi

