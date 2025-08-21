# 🚀 Dotflow

Minimal scripts to install and manage my [dotfiles](https://github.com/phucisstupid/dotfiles) and [dotfiles-stow](https://github.com/phucisstupid/dotfiles-stow) effortlessly.

## 🔹 Install Options

### **Nix ❄️**
Installs [Nix](https://nixos.org/), sets up your environment, symlinks config files, and runs your Nix flake.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/nix.sh)"
````

### **Stow 🏠**

Installs [Homebrew](https://brew.sh/), [Zinit](https://github.com/zdharma-continuum/zinit), then symlinks dotfiles using [GNU Stow](https://www.gnu.org/software/stow/).
Parent directories are auto-created before symlinks.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh)"
```

### **SketchyBar 🎨**

Clones and installs my [SketchyBar config](https://github.com/FelixKratz/SketchyBar).
Automatically symlinks config files and restarts SketchyBar.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh)" -- sketchybar
```

## 🔻 Uninstall

Remove symlinks and restore a clean state.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh)" -- uninstall
```

## ⚠️ Notes

* **Backup first**: Make sure you have copies of your current configs.
* **Dependencies**: Scripts will install required tools like `brew` and `stow`.
* **Personal extras**: Links `raycast` and `github-copilot` from `~/Documents/personal/`, auto-synced to iCloud ☁️.

---

## 😻 Enjoy your clean and minimal setup
