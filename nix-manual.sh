#!/bin/bash

# Exit immediately if any command fails
set -e

# Set environment variables
DOTFILES_STOW_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"

# Clone dotfiles repository
echo "🚀 Cloning dotfiles..."
cd ~
rm -rf "$DOTFILES_STOW_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles-stow.git "$DOTFILES_STOW_DIR"

# Remove existing .zshrc and .config directory
rm -f "$HOME/.zshrc"
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

# Symlink recommended config files
ln -sf "$DOTFILES_STOW_DIR/karabiner" "$CONFIG_DIR/karabiner"

# Ensure destination directories exist
mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"

ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR/raycast"

echo "🔗 Symlinked karabiner, raycast, and github-copilot"
echo "✅ Basic setup complete (no Nix)."
