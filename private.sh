#!/bin/bash
cd ~
git lfs install
git clone --depth 1 https://github.com/phucleeuwu/dotfiles
git lfs pull
rm -f ~/.zshrc
rm -rf ~/.config
mkdir -p ~/.config
openssl enc -aes-256-cbc -pbkdf2 -d -in ~/dotfiles/archive.tar.gz | tar -xvf - -C ~/dotfiles
openssl enc -aes-256-cbc -pbkdf2 -d -in ~/dotfiles/zed/archive.tar.gz | tar -xvf - -C ~/dotfiles/zed
cd dotfiles
stow -v .
stow -v zshrc -t ~
echo "✅ Installation complete"
