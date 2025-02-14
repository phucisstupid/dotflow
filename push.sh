#!/bin/bash
set -e
brew bundle dump --file=~/dotfiles/Brewfile --force
echo "✅ Brewfile updated!"
cd ~/dotfiles
lazygit
echo "✅ Complete!"
