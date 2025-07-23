
# 🚀 Arch Linux Cleanup Script (TUI Edition)

Tired of your Arch Linux looking like a digital hoarder's paradise? Fear not! This script will purge your system of all the unnecessary junk, orphaned packages, and outdated logs, leaving it cleaner than your conscience after deleting browser history. 🧹

## � Features

- **Minimal, colorful TUI** with emoji icons and clear sections
- **Shows disk usage before and after** cleanup
- **Cleans pacman, AUR, temp, user, and dev caches**
- **Removes orphaned packages**
- **Vacuum journal logs** (keep only 1 day)
- **Interactive confirmation** before running
- **Silent operation** with clear, color-coded feedback

---

## 🛠️ Installation & Usage

```bash
chmod +x c2.sh  # Make it executable
./c2.sh         # Run it (sudo will be prompted as needed)
```

---

## 🖥️ Preview

```
╔══════════════════════════════════════════════════════════╗
║                 Arch Linux System Cleaner               ║
╚══════════════════════════════════════════════════════════╝

📊 Current disk usage:
   Root: 195G used / 233G total (88% full)

⚠️  This will clean system caches and remove orphaned packages.
   Press ENTER to continue or Ctrl+C to cancel...

🚀 Starting cleanup process...

▶ Pacman Cache Cleanup
🧼 Clearing pacman cache...
✅ Pacman cache cleared
...
✨ System cleanup completed successfully!
ℹ️  Final disk usage:
   Root: 192G used / 233G total (87% full)
```

---

## ⚠️ Disclaimer

This script has the power to wipe things clean—so use it wisely! I'm not responsible if you accidentally summon the Linux gods by running this. 🙃

---

## 🏆 Why Use This?

- Because running `df -h` and seeing GBs freed up is satisfying.
- Because a bloated Arch system is basically not Arch. 😎
- Because you want a beautiful, interactive cleanup experience.

Enjoy your clean, minimal, and bloat-free Arch Linux! 🎉


