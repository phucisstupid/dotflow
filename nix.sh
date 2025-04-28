#!/usr/bin/env bash

set -euo pipefail

# 🔐 Ask for sudo password upfront
if [[ "$EUID" -ne 0 ]]; then
  echo "🔐 Sudo is required. Please enter your password."
  sudo -v
fi

# 🔁 Keep sudo alive in the background
(while true; do sudo -n true; sleep 60; done) &
KEEP_SUDO_ALIVE_PID=$!
trap 'kill $KEEP_SUDO_ALIVE_PID' EXIT

# 📦 Install Nix if not already installed
if ! command -v nix &> /dev/null; then
  echo "📥 Installing Nix using Lix installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix-shell -p git

# 📁 Set paths
DOTFILES_DIR="$HOME/dotfiles"
NIX_DIR="$HOME/nixos-config"
CONFIG_DIR="$HOME/.config"

# 🔄 Clone or reset dotfiles and Nix config repos
cd "$HOME"
rm -rf "$DOTFILES_DIR" "$NIX_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git "$DOTFILES_DIR"
git clone --depth 1 https://github.com/phucleeuwu/nixos-config.git "$NIX_DIR"

# ♻️ Reset .config and symlink custom config
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

ln -sf "$DOTFILES_DIR/karabiner" "$CONFIG_DIR/karabiner"

mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"

ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR/raycast"

echo "🔗 Symlinked karabiner, github-copilot, and raycast configs"

# 🔧 Update username in nixos-config/config.nix
sed -i '' "s/phuclee/$(whoami)/" "$NIX_DIR/config.nix"

# ▶️ Run Nix flake
echo "🌀 Running nix flake..."
nix run "$NIX_DIR"

# ✅ Done
echo "😻 Nix setup complete! Please restart your computer."
