#!/bin/bash
cd ~
git clone https://github.com/phucleeuwu/dotfiles ~/dotfiles
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config
openssl enc -aes-256-cbc -pbkdf2 -d -in ~/dotfiles/archive.tar.gz | tar -xvf - -C ~/dotfiles
openssl enc -aes-256-cbc -pbkdf2 -d -in ~/dotfiles/zed/archive.tar.gz | tar -xvf - -C ~/dotfiles/zed
cd dotfiles
stow -v .
stow -v zshrc -t ~
echo "✅ Installation complete"
