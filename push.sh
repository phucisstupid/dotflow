#!/bin/bash
set -e
cd ~/dotfiles
brew bundle dump --file=~/dotfiles/Brewfile --force
tar -cf - github-copilot raycast | openssl enc -aes-256-cbc -pbkdf2 -e -out archive.tar.gz
cd zed
tar -cf - conversations prompts | openssl enc -aes-256-cbc -pbkdf2 -e -out archive.tar.gz
cd ~/dotfiles              
lazygit
echo "✅ Complete!"
