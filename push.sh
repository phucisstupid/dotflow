#!/bin/bash
set -e
cd ~/dotfiles
brew bundle dump --file=~/dotfiles/Brewfile --force
echo "✅ Brewfile updated!"
lazygit
echo "✅ Complete!"
