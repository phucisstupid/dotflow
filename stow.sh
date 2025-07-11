#!/bin/bash
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

get_yes_no() {
  local prompt="$1" response
  while true; do
    read -p "$prompt (y/n) " response
    case "$response" in
    [Yy]) return 0 ;;
    [Nn]) return 1 ;;
    esac
  done
}

install_homebrew() {
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  case "$(uname)" in
  Darwin)
    [[ "$(uname -m)" == "arm64" ]] && eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
    ;;
  Linux)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
  esac
  success "Homebrew installed."
}

DOTFILES_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"

cd ~
rm -rf "$DOTFILES_DIR"
git clone --depth 1 https://github.com/phucisstupid/dotfiles-stow.git "$DOTFILES_DIR"
success "Cloned dotfiles-stow."

rm -f ~/.zshrc
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"
success "Reset .zshrc and .config."

if ! command -v brew &>/dev/null; then
  if get_yes_no "🍺 Homebrew not found. Install?"; then
    install_homebrew
  else
    log "Homebrew is required. Exiting."
    exit 1
  fi
else
  success "Homebrew already installed."
fi

command -v stow &>/dev/null || {
  log "Installing Stow..."
  brew install stow
  success "Stow installed."
}
command -v zinit &>/dev/null || {
  log "Installing Zinit..."
  brew install zinit
  success "Zinit installed."
}
command -v starship &>/dev/null || {
  log "Installing Starship..."
  brew install starship
  success "Starship installed."
}

cd "$DOTFILES_DIR"
stow .
stow simple-bar/ zsh/ -t ~
success "Applied stow configs."

mkdir -p "$HOME/Documents/personal/github-copilot"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR"
success "Symlinked GitHub Copilot configs."

if get_yes_no "✨ Install SketchyBar config and helpers?"; then
  log "Installing SketchyBar dependencies..."
  brew install lua switchaudio-osx nowplaying-cli
  brew tap FelixKratz/formulae
  brew install sketchybar
  brew install --cask sf-symbols font-sketchybar-app-font

  latest_tag=$(curl -s https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
  font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.lua"
  output_path="$CONFIG_DIR/sketchybar/helpers/icon_map.lua"
  mkdir -p "$(dirname "$output_path")"
  curl -L "$font_url" -o "$output_path"
  success "Downloaded icon_map.lua."

  log "Installing SbarLua..."
  (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
  success "SbarLua installed."

  brew services restart sketchybar
  sketchybar --reload
  success "SketchyBar loaded."
fi

BREWFILE="$DOTFILES_DIR/brew/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  if get_yes_no "🍺 Install Homebrew packages from Brewfile?"; then
    brew bundle --file="$BREWFILE"
    success "Installed packages from Brewfile."
  fi
fi

log "Dotfiles setup complete."
