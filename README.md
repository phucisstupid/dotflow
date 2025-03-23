# 🚀 Dotfiles Setup

Minimal scripts to install and manage my [dotfiles](https://github.com/phucleeuwu/dotfiles) effortlessly.

## **Note:** This script links `raycast` and `github-copilot` from `~/Documents/Personal/`, which are automatically backed up to iCloud ☁️ by Finder.

## 🔹 Install Options:

### **Nix ❄️**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/dotflow/main/nix.sh)"
```

---

### **Stow 🏠**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/phucleeuwu/dotflow/main/stow.sh)"
```
🛠 **What it does:**
- Clones [dotfiles](https://github.com/phucleeuwu/dotfiles) to `~/dotfiles`
- Ensures **Homebrew**, **Stow**, and **Zinit** are installed
- Uses **Stow** to symlink dotfiles:

---

## ⚠️ Important Notes

* **Backup:** Ensure you have backups of your current configurations before running these scripts.
* **Dependencies:** These scripts rely on tools like `git`, `stow` and `brew`. My script will install it for you.

For more information on managing dotfiles, you can refer to resources like [dotfiles.github.io](http://dotfiles.github.io) and [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles).
😻 **Enjoy your clean and minimal setup!**
