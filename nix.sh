#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# 🛡 Color definitions
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log() {
  echo -e "${YELLOW}➤ $1${RESET}"
}
success() {
  echo -e "${GREEN}✔ $1${RESET}"
}
error() {
  echo -e "${RED}✖ $1${RESET}"
  exit 1
}

# 🔐 Ask for sudo upfront
if [[ "$EUID" -ne 0 ]]; then
  log "Sudo is required. Please enter your password."
  sudo -v
fi

# 🔁 Keep sudo alive in background
(while true; do sudo -n true; sleep 60; done) &
KEEP_SUDO_ALIVE_PID=$!
trap 'kill "$KEEP_SUDO_ALIVE_PID" &>/dev/null' EXIT

# 📥 Install Nix (via Lix) if missing
if ! command -v nix &>/dev/null; then
  log "Installing Nix via Lix installer..."
  curl -sSfL https://install.lix.systems/lix | sh -s -- install --no-confirm
  /nix/nix-installer repair
  success "Nix installed."
else
  success "Nix is already installed."
fi

# 📁 Define paths
NIX_DIR="$HOME/dotfiles"
DOTFILES_STOW_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"

# 🔄 Clone repositories
log "Cloning dotfiles and dotfiles-stow..."
cd "$HOME"
rm -rf "$NIX_DIR" "$DOTFILES_STOW_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git "$NIX_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles-stow.git "$DOTFILES_STOW_DIR"
success "Repositories cloned."

# ♻️ Reset .config and link personal configs
log "Symlinking configurations..."
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
ln -sf "$DOTFILES_STOW_DIR/karabiner" "$CONFIG_DIR/karabiner"

mkdir -p "$HOME/Documents/personal/github-copilot"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
success "Symlinked karabiner and github-copilot configs."

# 🔧 Replace username placeholder in config.nix
CONFIG_NIX="$NIX_DIR/config.nix"
if [[ -f "$CONFIG_NIX" ]]; then
  log "Replacing username in config.nix..."
  uname=$(whoami)
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s/wow/${uname}/g" "$CONFIG_NIX"
  else
    sed -i "s/wow/${uname}/g" "$CONFIG_NIX"
  fi
  success "Username updated to ${uname} in config.nix."
else
  log "⚠ No config.nix found. Skipping username update."
fi

# ▶️ Run flake
log "Running nix flake..."
nix run "$NIX_DIR"
success "Nix flake run complete."

# 🎉 Done
echo -e "${GREEN}🎉 Setup complete!${RESET}"
echo "📌 Please allow accessibility permissions for apps and restart your computer."
