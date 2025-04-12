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
echo "🔗 Symlinking ghostty, and karabiner..."
ln -sf "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty"
ln -sf "$DOTFILES_DIR/karabiner" "$CONFIG_DIR/karabiner"
echo  "Symlinked"

# Symlink recommended config files
mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR/raycast"
echo "✅ Symlinked raycast and github-copilot"
#!/usr/bin/env bash

# Ask for sudo password upfront
if sudo -v; then
  # Keep sudo alive while script runs
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
else
  echo "Sudo authentication failed."
  exit 1
fi

# Install Nix using Determinate Systems installer with custom config
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --no-confirm --determinate

# Source Nix profile into current shell (covers both macOS and Linux cases)
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# Run your dotfiles setup
nix run github:phucleeuwu/dotfiles
cd dotfiles
# Final notice
echo "😻 Nix setup complete! All dotfiles have been symlinked."
