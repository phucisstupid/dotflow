#!/bin/bash

# Exit immediately if any command fails
set -e

# Function to install Homebrew
install_homebrew() {
    echo "🔍 Homebrew not found. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Ensure Homebrew is in the PATH (especially for Apple Silicon Macs)
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew installation failed. Please install it manually from https://brew.sh/"
        exit 1
    fi
    echo "✅ Homebrew installed successfully!"
}

# Check if Homebrew is installed, prompt user to install if missing
if ! command -v brew &> /dev/null; then
    read -p "🍺 Homebrew is not installed. Do you want to install it now? (y/n) " install_brew
    if [[ "$install_brew" =~ ^[Yy]$ ]]; then
        install_homebrew
    else
        echo "❌ Homebrew is required for this script. Exiting."
        exit 1
    fi
fi

# Clone dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🚀 Setting up dotfiles..."
cd ~
rm -rf "$DOTFILES_DIR"
git clone --depth 1 https://github.com/phucleeuwu/dotfiles.git "$DOTFILES_DIR"

# Remove existing .zshrc and .config
rm -f ~/.zshrc
rm -rf "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR"

# Use GNU Stow to manage dotfiles
cd "$DOTFILES_DIR"
stow -v .
stow -v zshrc -t ~

# Ask if user wants to remove unwanted files
read -p "🗑 Do you want to remove unwanted files (e.g., .gitignore, .stowrc, raycastconf)? (y/n) " rm_unwanted
if [[ "$rm_unwanted" =~ ^[Yy]$ ]]; then
    rm -rf .git .gitignore README.md raycastconf
    echo "✅ Unwanted files removed."
else
    ln -s ~/Documents/Dev/github-copilot "$CONFIG_DIR/github-copilot"
    echo "✅ Symlink created for GitHub Copilot."
fi

# Ask if user wants to install Brew packages
BREWFILE="$DOTFILES_DIR/Brewfile"
if [[ -f "$BREWFILE" ]]; then
    read -p "🍺 Do you want to install recommend Homebrew packages (Optional)? (y/n) " install_brew
    if [[ "$install_brew" =~ ^[Yy]$ ]]; then
        brew bundle --file="$BREWFILE"
    else    
        echo "⏭ Skipping Homebrew package installation."
    fi
else
    echo "⚠ No Brewfile found in ~/dotfiles. Skipping Homebrew package installation."
fi

# Final notice
echo "🎉 Setup complete! All dotfiles have been symlinked and configured."
echo "🛠 If you make any changes to your dotfiles, remember to apply them using: "
echo "   $ cd ~/dotfiles && stow ."
