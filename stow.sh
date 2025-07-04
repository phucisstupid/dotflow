#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

if [[ "$EUID" -ne 0 ]]; then
  log "Sudo is required. Please enter your password."
  sudo -v
fi

# Function to install Homebrew
install_homebrew() {
  echo "🔍 Homebrew not found. Installing now..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  case "$(uname)" in
    "Darwin")
      if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi
      ;;
    "Linux")
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      ;;
  esac

  if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew installation failed. Please install manually from https://brew.sh/"
    exit 1
  fi
}

# Prompt for y/n input
get_yes_no() {
  local prompt="$1"
  local response
  while true; do
    read -p "$prompt (y/n) " response
    case "$response" in
      [Yy]) return 0 ;;
      [Nn]) return 1 ;;
      *) echo "❌ Invalid input. Please type y or n." ;;
    esac
  done
}

# Directories
DOTFILES_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"

# Clone dotfiles
echo "🚀 Cloning dotfiles-stow..."
cd ~
rm -rf "$DOTFILES_DIR"
git clone --depth 1 https://github.com/phucisstupid/dotfiles-stow.git "$DOTFILES_DIR"

# Reset config and .zshrc
rm -f ~/.zshrc
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  if get_yes_no "🍺 Homebrew is not installed. Install now?"; then
    install_homebrew
  else
    echo "❌ Homebrew is required. Exiting."
    exit 1
  fi
fi

# Install stow if missing
if ! command -v stow &>/dev/null; then
  echo "📦 Installing Stow..."
  brew install stow
fi

# Install zinit if missing
if ! command -v zinit &>/dev/null; then
  echo "📦 Installing Zinit..."
  brew install zinit
fi

# Install starship if missing
if ! command -v starship &>/dev/null; then
  echo "📦 Installing Starship..."
  brew install starship
fi

# Apply Stow
cd "$DOTFILES_DIR"
stow .
stow simple-bar/ zsh/ -t ~

# Symlink personal configs
mkdir -p "$HOME/Documents/personal/github-copilot"
mkdir -p "$HOME/Documents/personal/raycast"
ln -sf "$HOME/Documents/personal/github-copilot" "$CONFIG_DIR"
ln -sf "$HOME/Documents/personal/raycast" "$CONFIG_DIR"
echo "🔗 Symlinked GitHub Copilot and Raycast configs"

# Ask to install SketchyBar config
if get_yes_no "✨ Do you want to install my SketchyBar config and helpers?"; then
  echo "📦 Installing dependencies for SketchyBar..."

  brew install lua switchaudio-osx nowplaying-cli

  brew tap FelixKratz/formulae
  brew install sketchybar

  # Fonts
  brew install --cask sf-symbols
  brew install --cask font-sketchybar-app-font

  # Download latest icon_map.lua
  latest_tag=$(curl -s https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
  font_url="https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.lua"
  output_path="$CONFIG_DIR/sketchybar/helpers/icon_map.lua"
  mkdir -p "$(dirname "$output_path")"
  curl -L "$font_url" -o "$output_path"

  echo "📄 Installed icon_map.lua version $latest_tag to $output_path"

  # Install SbarLua
  echo "📁 Installing SbarLua..."
  git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
  (cd /tmp/SbarLua && make install)
  rm -rf /tmp/SbarLua

  # Restart SketchyBar
  brew services restart sketchybar
  sketchybar --reload
fi

# Install Brewfile packages
BREWFILE="$DOTFILES_DIR/brew/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  if get_yes_no "🍺 Install Homebrew packages from Brewfile?"; then
    brew bundle --file="$BREWFILE"
  fi
else
  echo "⚠️ No Brewfile found in $DOTFILES_DIR"
fi

# Final message
echo "✅ Dotfiles setup complete!"
echo "🏠 To re-apply dotfiles in the future: cd ~/dotfiles-stow && stow ."
