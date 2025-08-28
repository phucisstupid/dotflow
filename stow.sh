#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

trap 'echo -e "\n\033[0;31m✘ Interrupted. Exiting...\033[0m"; exit 1' INT

# ----------------------
# 🎨 COLORS & HELPERS
# ----------------------
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log()     { echo -e "${YELLOW}➤ $1${RESET}"; }
success() { echo -e "${GREEN}✔ $1${RESET}"; }
error()   { echo -e "${RED}✘ $1${RESET}" >&2; }

get_yes_no() {
  local prompt="$1" response
  while true; do
    read -rp "$prompt (y/n) " response
    case "$response" in
      [Yy]) return 0 ;;
      [Nn]) return 1 ;;
    esac
  done
}

# ----------------------
# 🍺 HOMEBREW
# ----------------------
install_homebrew() {
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  case "$(uname -s)" in
    Darwin)
      if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        eval "$(/usr/local/bin/brew shellenv)"
      fi
      ;;
    Linux)
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      ;;
  esac
  success "Homebrew installed."
}

ensure_homebrew() {
  if ! command -v brew &>/dev/null; then
    get_yes_no "🍺 Homebrew not found. Install?" && install_homebrew || {
      error "Homebrew is required. Exiting."
      exit 1
    }
  else
    success "Homebrew already installed."
  fi
}

# ----------------------
# 📂 PATHS
# ----------------------
DOTFILES_DIR="$HOME/dotfiles-stow"
CONFIG_DIR="$HOME/.config"
MODE="${1:-all}" # accepts: all | sketchybar | uninstall

# ----------------------
# 🔄 INSTALL
# ----------------------
install_dotfiles() {
  rm -rf -- "$DOTFILES_DIR"
  git clone --depth 1 https://github.com/phucisstupid/dotfiles-stow.git "$DOTFILES_DIR"
  success "Cloned dotfiles-stow."

  if [[ "$MODE" == "all" ]]; then
    rm -f -- "$HOME/.zshrc"
    rm -rf -- "$CONFIG_DIR"
    success "Reset .config and .zshrc"

    log "Installing base packages..."
    brew install stow zinit starship
    success "Installed stow, zinit, starship."

    (cd "$DOTFILES_DIR" && stow --verbose .)
    success "Applied stow configs."
    
    if get_yes_no "✨ Install tmux plugins manger?"; then
      git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      success "Installed tmux plugins manager, open tmux run <C-a> + shift I."
    fi
    
    BREWFILE="$DOTFILES_DIR/brew/Brewfile"
    if [[ -f "$BREWFILE" ]] && get_yes_no "🍺 Install packages from Brewfile? (optional)"; then
      brew bundle --file="$BREWFILE"
      success "Installed Brewfile packages."
    fi
  fi
}

symlink_sketchybar() {
  log "Symlinking SketchyBar config..."
  rm -rf -- "$CONFIG_DIR/sketchybar"
  ln -sf "$DOTFILES_DIR/.config/sketchybar" "$CONFIG_DIR/sketchybar"
  success "Symlinked SketchyBar config."
}

install_sketchybar() {
  if get_yes_no "✨ Install SketchyBar dependencies and helpers?"; then
    log "Fetching latest icon_map.lua..."
    latest_tag=$(curl -fsSL https://api.github.com/repos/kvndrsslr/sketchybar-app-font/releases/latest \
      | jq -r .tag_name)

    output_path="$CONFIG_DIR/sketchybar/helpers/icon_map.lua"
    mkdir -p "$(dirname "$output_path")"
    curl -fsSL "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${latest_tag}/icon_map.lua" \
      -o "$output_path"
    success "Downloaded icon_map.lua ($latest_tag)."

    log "Installing SketchyBar dependencies..."
    brew install lua switchaudio-osx nowplaying-cli
    brew tap FelixKratz/formulae
    brew install sketchybar
    brew install --cask sf-symbols font-sketchybar-app-font font-maple-mono
    success "Installed dependencies."

    log "Installing SbarLua..."
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    git clone --quiet https://github.com/FelixKratz/SbarLua.git "$tmpdir"
    (cd "$tmpdir" && make install)
    success "SbarLua installed."

    brew services restart sketchybar
    sketchybar --reload
    success "SketchyBar loaded."
  fi
}

# ----------------------
# ❌ UNINSTALL
# ----------------------
uninstall_all() {
  log "Removing symlinks and configs..."
  rm -f -- "$HOME/.zshrc"
  rm -rf -- "$CONFIG_DIR"
  rm -rf -- "$DOTFILES_DIR"
  success "Removed dotfiles and configs."

  if get_yes_no "🍺 Uninstall Homebrew packages?"; then
    brew uninstall --force stow zinit starship lua switchaudio-osx nowplaying-cli sketchybar || true
    brew uninstall --cask --force sf-symbols font-sketchybar-app-font font-maple-mono || true
    success "Removed Homebrew packages."
  fi

  if get_yes_no "🧹 Remove Homebrew completely?"; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    success "Homebrew removed."
  fi

  success "Uninstall complete."
}

# ----------------------
# 🚀 MAIN
# ----------------------
case "$MODE" in
  all)
    ensure_homebrew
    install_dotfiles
    install_sketchybar
    ;;
  sketchybar)
    ensure_homebrew
    symlink_sketchybar
    install_sketchybar
    ;;
  uninstall)
    uninstall_all
    ;;
  *)
    error "Unknown mode: $MODE (use: all | sketchybar | uninstall)"
    exit 1
    ;;
esac

success "✅ Operation finished."
