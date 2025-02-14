#!/bin/bash
set -e
cd ~/dotfiles
brew bundle dump --file=~/dotfiles/Brewfile --force       
lazygit
echo "✅ Complete!"
