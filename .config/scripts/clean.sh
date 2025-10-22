#!/bin/bash
set -e

echo "=== Starting system update ==="


echo "[1/6] Updating AUR packages with yay..."
yay -Syu --noconfirm

echo "[2/6] Updating flatpak packages..."
flatpak update -y

# Remove orphaned packages (root needed)
echo "[3/6] Checking for orphaned packages..."
orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    echo "Removing orphaned packages: $orphans"
    sudo pacman -Rns --noconfirm $orphans
else
    echo "No orphaned packages found."
fi

# Clear old package cache but keep the latest one (root needed)
echo "[4/6] Cleaning pacman cache..."
sudo paccache -ruk0

# Clean yay cache
echo "[6/6] Cleaning yay cache..."
yay -Scc --noconfirm

echo "=== System cleanup completed successfully! ==="

