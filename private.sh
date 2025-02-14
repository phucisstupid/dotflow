#!/bin/bash
set -e
cd ~
rm -rf dotfiles
git clone --depth 1 https://github.com/phucleeuwu/dotfiles
cd ~/dotfiles
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config
stow -v .
stow -v zshrc -t ~
exit
echo "✅ Installation complete"
