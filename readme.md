# Dotfiles - My Arch Linux Configuration

This repository contains my personal **dotfiles** for managing my Arch Linux setup. These configurations are stored in one place and linked using **symbolic links**, making it easy to maintain and sync across multiple systems.

## **Included Configurations**
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Launcher**: [Rofi](https://github.com/davatorium/rofi)
- **Status Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **Shell**: `bashrc`
- **System Info**: [Fastfetch](https://github.com/fastfetch-cli/fastfetch)
- **Installation Script**: `install.sh` (automates symlink creation)

## **Installation**
Clone the repository:
```sh
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the installation script to create symbolic links:
```sh
./install.sh
```

## **Symlink Setup**
The **install.sh** script creates symlinks so that all configurations stay in `~/dotfiles` but are used system-wide. Example:
```sh
ln -s ./kitty ~/.config/kitty
ln -s ./rofi ~/.config/rofi
ln -s ./waybar ~/.config/waybar
ln -s ./bashrc/.bashrc ~/.bashrc
ln -s ./fastfetch ~/.config/fastfetch
```


Feel free to fork and customize this setup to fit your workflow! 🚀


