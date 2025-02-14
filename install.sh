#!/bin/bash

# Exit immediately if any command fails
set -e

# Go to home directory
cd ~
rm -rf dotfiles
git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git

# Remove existing ~/.config and recreate it
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config

# Link config
cd dotfiles
stow -v .
stow -v zshrc -t ~

# Ask if user wants to remove unwanted files (excluding zed folder but removing its archive.tar.gz)
read -p "Do you want to remove unwanted files (e.g., .gitignore, .stowrc, and raycastconf)? (y/n) " rm_unwanted
if [[ "$rm_unwanted" =~ ^[Yy]$ ]]; then
    rm -rf .gitignore .stow-local-ignore .stowrc README.md raycastconf
    echo "✅ Unwanted files removed."
else
    ln -s ~/Documents/Dev/github-copilot ~/.config/github-copilot
    echo "✅ Symlink created for GitHub Copilot."
fi

# Installation complete message
echo "✅ Installation complete! All files from ~/dotfiles are now symlinked to ~/.config/"
