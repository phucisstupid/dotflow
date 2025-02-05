#!/bin/bash

# Go to home directory
cd ~
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git
# Remove existing ~/.config and recreate it
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config

# Link config
cd dotfiles
stow -v .
stow -v zshrc -t ~
rm -rf .gitignore .stow-local-ignore .stowrc README.md archive.tar.gz .git .gitattributes
cd zed rm -rf archive.tar.gz
echo "✅ Installation complete! All files from ~/dotfiles are now symlinked to ~/.config/"
