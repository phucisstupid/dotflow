# 🚀 Dotflow

Minimal scripts to install and manage my [dotfiles](https://github.com/phucisstupid/dotfiles) effortlessly.

## 🔹 Install Options:

### **Nix ❄️**
Installs [Lix](https://docs.lix.systems/manual/lix), sets up your environment, symlinks config files, and runs your Nix flake.
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/nix.sh)"
```

### **Stow 🏠**
Installs [Homebrew](https://brew.sh/), [Zinit](https://github.com/zdharma-continuum/zinit), then symlinks dotfiles using [GNU Stow](https://www.gnu.org/software/stow/).
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh)"
```

## Important ⚠️

* **Backup:** Ensure you have backups of your current configurations.
* **Dependencies:** These scripts rely on tools like `stow` and `brew`. My script will install it for you.
* **Personal Extras:** links `raycast` and `github-copilot` from `~/Documents/personal/`, which are automatically backed up to my iCloud ☁️ by Finder.

##  **Enjoy your clean and minimal setup 😻**
