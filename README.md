
# Dotfiles manager
## 📦 install Repository

This repository contains scripts to facilitate the installation and management of dotfiles from the [dotfiles repository](https://github.com/phucleeuwu/dotfiles).

## 📜 Available Scripts

### 1. Install Script

> This script will link `raycast` and `github-copilot` from `~/Documents/Personal/*` unless you choose to delete unnecessary files. These folders are stored there for convenience as Finder backs them up to iCloud.

**Purpose:** Clones the dotfiles repository and sets up symbolic links to integrate the configurations into your system.

**Usage:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/Dotflow/main/i.sh)
```

**What It Does:**

* Clones the dotfiles repository to your home directory.
* Removes existing `.zshrc` and `.config` to prevent conflicts.
* Creates a new `.config` directory.
* Uses `stow` to create symbolic links for the configurations.

### 2. Push Script

**Purpose:** Backs up your current dotfiles, including specific configurations like GitHub Copilot and Raycast, and pushes them to the remote dotfiles repository.

**Usage:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/Dotflow/main/push.sh)
```

**What It Does:**

* Dumps Homebrew packages into a Brewfile.
* Commits and pushes by `lazygit`.

## ⚠️ Important Notes

* **Backup:** Ensure you have backups of your current configurations before running these scripts.
* **Dependencies:** These scripts rely on tools like `git`, `stow`, `openssl`, and `brew`. Make sure they are installed on your system.
* **Security:** The `private.sh` script handles encrypted data. Ensure your environment is secure and you trust the source of these scripts.

For more information on managing dotfiles, you can refer to resources like [dotfiles.github.io](http://dotfiles.github.io) and [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles).
