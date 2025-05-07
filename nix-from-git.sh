#!/bin/bash

# Exit immediately if any command fails
set -e

# Ask for sudo password upfront
if [ "$EUID" -ne 0 ]; then
  echo "🔐 Sudo is required. Please enter your password."
  sudo -v
fi

# Keep sudo alive until the script ends
( while true; do sudo -v; sleep 60; done ) &
KEEP_SUDO_ALIVE_PID=$!
trap 'kill $KEEP_SUDO_ALIVE_PID' EXIT

# Install Nix using Determinate Systems installer
if ! command -v nix &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install --determinate --no-confirm

  # Source Nix environment (important for immediate use)
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Run your Nix flake from GitHub
nix run github:phucleeuwu/dotfiles

echo "🎉 Nix flake execution complete!"
