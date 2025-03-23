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

# Symlink specific configuration files instead of using Stow
echo "🔗 Symlinking aerospace, ghostty, and karabiner..."
ln -sf "$DOTFILES_DIR/aerospace" "$CONFIG_DIR/aerospace"
ln -sf "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
ln -sf "$DOTFILES_DIR/karabiner" "$CONFIG_DIR/karabiner"
echo "✅ Symlinked"

# Symlink recommended config files
mkdir -p "$HOME/Documents/Personal/github-copilot"
mkdir -p "$HOME/Documents/Personal/raycast"
ln -sf "$HOME/Documents/Personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/Personal/raycast" "$CONFIG_DIR/raycast"
echo "🔗 Symlinked raycast and github-copilot"

# Final notice
echo "😻 Nix setup complete! All dotfiles have been symlinked."
