#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

log() { echo -e "${YELLOW}➤ $1${RESET}"; }
success() { echo -e "${GREEN}✔ $1${RESET}"; }

if [[ "$EUID" -ne 0 ]]; then
  log "Sudo required. Enter your password."
  sudo -v
fi

(while true; do
  sudo -n true
  sleep 60
done) &
KEEP_SUDO_ALIVE_PID=$!
trap 'kill "$KEEP_SUDO_ALIVE_PID" &>/dev/null' EXIT

if ! command -v nix &>/dev/null; then
  log "Installing Nix..."
  curl -sSfL https://install.lix.systems/lix | sh -s -- install --no-confirm
  /nix/nix-installer repair
  success "Nix installed."
else
  success "Nix already installed."
fi

NIX_DIR="$HOME/dotfiles"
STOW_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"

log "Cloning dotfiles..."
cd "$HOME"
rm -rf "$NIX_DIR" "$STOW_DIR"
git clone --depth 1 https://github.com/phucisstupid/dotfiles.git "$NIX_DIR"
git clone --depth 1 https://github.com/phucisstupid/dotfiles-stow.git "$STOW_DIR"
success "Cloned."

log "Linking configs..."
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
ln -sf "$STOW_DIR/karabiner" "$CONFIG_DIR/karabiner"
mkdir -p "$HOME/Documents/personal/github-copilot"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR/github-copilot"
success "Configs linked."

CONFIG_NIX="$NIX_DIR/config.nix"
DARWIN_HOST=$(hostname -s)
DARWIN_PATH="$NIX_DIR/configurations/darwin/$DARWIN_HOST"
SOURCE_NIX="$NIX_DIR/configurations/darwin/192/default.nix"

if [[ -f "$CONFIG_NIX" ]]; then
  uname=$(whoami)
  if [[ "$(uname)" == "Darwin" ]]; then
    log "Replacing config.nix username with '$uname' and creating Darwin host for '$DARWIN_HOST'..."
    mkdir -p "$DARWIN_PATH"
    rsync -a "$SOURCE_NIX" "$DARWIN_PATH/default.nix"
    sed -i '' "s/wow/${uname}/g" "$CONFIG_NIX"
  else
    sed -i "s/wow/${uname}/g" "$CONFIG_NIX"
  fi
  success "Updated config.nix username and created host."
fi

log "Running flake..."
nix run "$NIX_DIR"
success "Flake complete."

echo "Setup complete. Allow accessibility permissions and restart your computer."

