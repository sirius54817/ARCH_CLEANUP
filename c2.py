#!/bin/bash

echo "🧹 Starting full system cache cleanup on Arch Linux..."

# 1. Pacman cache
echo "🧼 Clearing pacman cache..."
sudo pacman -Scc --noconfirm
sudo rm -rf /var/cache/pacman/pkg/*

# 2. Temp files
echo "🧼 Clearing temporary system files..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# 3. User cache
echo "🧼 Clearing user cache..."
rm -rf ~/.cache/*
echo "🧼 Clearing all users' cache (if any)..."
sudo rm -rf /home/*/.cache/*

# 4. Journal logs
echo "🧼 Vacuuming journal logs (keeping 1 day)..."
sudo journalctl --vacuum-time=1d

# 5. Thumbnail cache
echo "🧼 Clearing thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

# 6. Orphaned packages
echo "🧼 Removing orphaned packages..."
orphans=$(pacman -Qdtq)
if [ -n "$orphans" ]; then
    sudo pacman -Rns --noconfirm $orphans
else
    echo "✅ No orphaned packages found."
fi

# 7. AUR helpers
if command -v yay &> /dev/null; then
    echo "🧼 Cleaning yay cache..."
    yay -Sc --noconfirm
fi

if command -v paru &> /dev/null; then
    echo "🧼 Cleaning paru cache..."
    paru -Sc --noconfirm
fi

# 8. Dev tool caches
echo "🧼 Cleaning npm, pip, cargo, flatpak caches..."
rm -rf ~/.npm/_cacache
rm -rf ~/.cache/pip
rm -rf ~/.cache/cargo

if command -v flatpak &> /dev/null; then
    flatpak uninstall --unused -y
fi

echo "✅ System cleanup completed."
