#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ----------------------
# 🎨 COLORS & HELPERS
# ----------------------
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log()     { echo -e "${YELLOW}➤ $1${RESET}"; }
success() { echo -e "${GREEN}✔ $1${RESET}"; }
warn()    { echo -e "${RED}✘ $1${RESET}"; }

# ----------------------
# 🔑 SUDO KEEP-ALIVE
# ----------------------
if [[ "$EUID" -ne 0 ]]; then
  log "Sudo required. Enter your password."
  sudo -v
fi

# keep sudo alive until script exits
( while true; do sudo -n true; sleep 60; done ) &
KEEP_SUDO_ALIVE_PID=$!
trap 'kill "$KEEP_SUDO_ALIVE_PID" >/dev/null 2>&1' EXIT

# ----------------------
# 📦 NIX INSTALL
# ----------------------
if ! command -v nix >/dev/null 2>&1; then
  log "Installing Nix..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
  if command -v /nix/nix-installer >/dev/null 2>&1; then
    /nix/nix-installer repair
  fi
  success "Nix installed."
else
  success "Nix already installed."
fi

# ----------------------
# 📂 DIRECTORIES
# ----------------------
NIX_DIR="$HOME/dotfiles"

log "Cloning dotfiles..."
cd "$HOME"
rm -rf "$NIX_DIR"
git clone --depth 1 https://github.com/phucisstupid/dotfiles.git "$NIX_DIR"
success "Cloned dotfiles repos."

# ----------------------
# ⚙️ NIX
# ----------------------
CONFIG_NIX="$NIX_DIR/config.nix"
DARWIN_HOST=$(hostname -s)
DARWIN_PATH="$NIX_DIR/configurations/darwin/$DARWIN_HOST"
SOURCE_NIX="$NIX_DIR/configurations/darwin/192/default.nix"
USER_NAME="$(whoami)"

if [[ -f "$CONFIG_NIX" ]]; then
  if [[ "$(uname)" == "Darwin" ]]; then
    log "Setting username in config.nix and preparing Darwin host '$DARWIN_HOST'..."

    # Create Darwin host directory if it doesn't exist
    if [[ ! -d "$DARWIN_PATH" ]]; then
      mkdir -p "$DARWIN_PATH"
      cp "$SOURCE_NIX" "$DARWIN_PATH/default.nix"
      log "Copied default.nix to '$DARWIN_PATH'."
      
      if git -C "$NIX_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git -C "$NIX_DIR" add "$DARWIN_PATH/default.nix"
        log "Added '$DARWIN_PATH/default.nix' to git."
      fi
    else
      log "Darwin host '$DARWIN_HOST' already exists, skipping copy."
    fi

    # Replace username in config.nix
    sed -i '' "s/wow/${USER_NAME}/g" "$CONFIG_NIX"

    # Replace networking.hostName in the copied default.nix
    sed -i '' "s/networking\.hostName = \"192\";/networking.hostName = \"$DARWIN_HOST\";/g" "$DARWIN_PATH/default.nix"

  else
    sed -i "s/wow/${USER_NAME}/g" "$CONFIG_NIX"
  fi

  success "Updated config.nix and Darwin host configuration for user '$USER_NAME'."
fi

# ----------------------
# 🚀 RUN FLAKE
# ----------------------
log "Running flake..."
nix run "$NIX_DIR"
success "Flake complete."

echo -e "\n${GREEN}✅ Setup complete.${RESET} Allow accessibility permissions and restart your computer."
