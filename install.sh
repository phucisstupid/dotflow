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

# Clean up unwanted files
rm -rf .gitignore .stow-local-ignore .stowrc README.md archive.tar.gz .git .gitattributes

# Go into zed folder and remove archive
cd zed
rm -rf archive.tar.gz

# Apply the new zshrc
source ~/.zshrc

# Script finished, exit terminal
exit

# If you reach here, it means no errors occurred
echo "✅ Installation complete! All files from ~/dotfiles are now symlinked to ~/.config/"
