#!/bin/bash

# Exit immediately if any command fails
set -e

# Ask for sudo password upfront
if [ "$EUID" -ne 0 ]; then
  echo "🔐 Sudo is required. Please enter your password."
  sudo -v
fi

# Keep sudo alive until the script ends
# This runs `sudo -v` every 60 seconds in the background
# and kills it once the script finishes
( while true; do sudo -v; sleep 60; done ) &
KEEP_SUDO_ALIVE_PID=$!

# Ensure cleanup on script exit
trap 'kill $KEEP_SUDO_ALIVE_PID' EXIT

# Install Nix using Determinate Systems installer
if ! command -v nix &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install --determinate --no-confirm
  # Source Nix environment (important for immediate use)
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Set environment variables
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

# Run your Nix flake from GitHub
nix run "$DOTFILES_DIR/nix"

# Final notice
echo "😻 Nix setup complete! Dotfiles installed and flake executed."
