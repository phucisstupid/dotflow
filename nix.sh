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
ln -sf "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
ln -sf "$DOTFILES_DIR/karabiner" "$CONFIG_DIR/karabiner"
echo "🔗 Symlinked ghostty, and karabiner..."

# Symlink recommended config files
mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR/raycast"
echo "🔗 Symlinked raycast and github-copilot"

# Install Nix using Determinate Systems installer with custom config
echo "❄️ Install Nix using Determinate Systems"
sudo curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --no-confirm --determinate

# Run your dotfiles setup
echo "Setup dotfiles"
nix run github:phucleeuwu/dotfiles
cd dotfiles
# Final notice
echo "😻 Nix setup complete! All dotfiles have been symlinked."
