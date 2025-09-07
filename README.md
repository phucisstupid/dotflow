# 🚀 Dotflow

Minimal scripts to install and manage my [dotfiles](https://github.com/phucisstupid/dotfiles) and [dotfiles-stow](https://github.com/phucisstupid/dotfiles-stow) effortlessly.  

## 🔹 Install Options

### **Nix ❄️**
Installs [Nix](https://nixos.org/), sets up your environment, symlinks config files, and runs your Nix flake.

```bash
curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/nix.sh | sh -s
````

### **Stow 🏠**

Installs [Homebrew](https://brew.sh/), [Zinit](https://github.com/zdharma-continuum/zinit), then symlinks dotfiles using [GNU Stow](https://www.gnu.org/software/stow/).
Before symlinking, any existing files (like `.zshrc`, `.simplebarrc`, `~/.config/`) are automatically renamed with a `.bak` suffix for backup.

```bash
curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh | sh -s
```

### **SketchyBar 🎨**

Clones and installs my [SketchyBar config](https://github.com/phucisstupid/dotfiles-stow/blob/main/.config/sketchybar).

```bash
curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh | sh -s -- sketchybar
```

## 🔻 Uninstall

Removes symlinks and installed configs.
If a backup exists (e.g., `~/.config.bak`), it will be **restored to the original file** automatically.

```bash
curl -fsSL https://raw.githubusercontent.com/phucisstupid/dotflow/main/stow.sh | sh -s -- uninstall
```

## ⚠️ Notes

* **Automatic backups**: Existing configs are renamed to `.bak` instead of deleted.
* **Safe uninstall**: `.bak` files are restored back to their original names.
* **Dependencies**: Scripts will install required tools like `brew`, `stow`, `zinit`.
* **Personal extras**: Links `raycast` and `github-copilot` from `~/Documents/personal/`, auto-synced to iCloud ☁️.

---

## 😻 Enjoy your clean and minimal setup

