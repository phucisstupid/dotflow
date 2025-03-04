
# Dotfiles manager
This repository contains scripts to facilitate the installation and management of dotfiles from the [dotfiles repository](https://github.com/phucleeuwu/dotfiles).

## 1. Install Script

> This script will link `raycast` and `github-copilot` from `~/Documents/Personal/*` unless you choose to delete unnecessary files. These folders are stored there for convenience as Finder backs them up to iCloud.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/Dotflow/main/i.sh)
```

**What It Does:**

* Clones the dotfiles repository to your home directory.
* Removes existing `.zshrc` and `.config` to prevent conflicts.
* Uses `stow` to create symbolic links for the configurations.
* Ask to install my `Homebrew` packages

## 2. Push Script

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/Dotflow/main/push.sh)
```

**What It Does:**

* Dumps Homebrew packages into a Brewfile.
* Commits and pushes by `lazygit`.

## ⚠️ Important Notes

* **Backup:** Ensure you have backups of your current configurations before running these scripts.
* **Dependencies:** These scripts rely on tools like `git`, `stow` and `brew`. My script will install it for you.

For more information on managing dotfiles, you can refer to resources like [dotfiles.github.io](http://dotfiles.github.io) and [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles).
