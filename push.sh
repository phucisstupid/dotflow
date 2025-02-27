#!/bin/bash
set -e
brew bundle dump --file=~/dotfiles/brew/Brewfile --force
echo "✅ Brewfile updated!"
cd ~/dotfiles
git add .         
git commit -m "My dotfiles synced from remote machines"
git branch -M main 
git push
echo "✅ Complete!"
