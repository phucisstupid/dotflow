#!/bin/bash

# Exit immediately if any command fails
set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Clone dotfiles repository
echo "🚀 Setting up dotfiles with Nix..."
cd ~
rm -rf "$DOTFILES_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git "$DOTFILES_DIR"

# Remove existing .zshrc and .config
rm -f ~/.zshrc
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

# Symlink recommended config files
ln -sf "$DOTFILES_DIR/karabiner" "$CONFIG_DIR/karabiner"
mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR/raycast"
echo "🔗 Symlinked karabiner, raycast and github-copilot"
cd dotfiles
# Final notice
echo "😻 Nix setup complete! All dotfiles have been symlinked."
