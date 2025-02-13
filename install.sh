#!/bin/bash

# Exit immediately if any command fails
set -e

# Go to home directory
cd ~
rm -rf dotfiles
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git

# Remove existing ~/.config and recreate it
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config

# Link config
cd dotfiles
stow -v .
stow -v zshrc -t ~

# Ask if user wants to remove unwanted files (excluding zed folder but removing its archive.tar.gz)
read -p "Do you want to remove unwanted files (e.g., .gitignore, .stowrc, and zed/archive.tar.gz)? (y/n) " rm_unwanted
if [[ "$rm_unwanted" =~ ^[Yy]$ ]]; then
    rm -rf .gitignore .stow-local-ignore .stowrc README.md archive.tar.gz .git .gitattributes
    if [[ -f "zed/archive.tar.gz" ]]; then
        rm -rf zed/archive.tar.gz
    fi
    echo "✅ Unwanted files removed."
fi

# Apply the new zshrc
source ~/.zshrc

# Installation complete message
echo "✅ Installation complete! All files from ~/dotfiles are now symlinked to ~/.config/"

# Exit terminal
exit
