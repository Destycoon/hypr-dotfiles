#!/bin/bash
set -e

echo "=== Starting system update ==="

# Update system packages with pacman (root needed)
echo "[1/6] Updating system with pacman..."
sudo pacman -Syu --noconfirm

# Update AUR packages with yay (must be run as user)
echo "[2/6] Updating AUR packages with yay..."
yay -Syu --noconfirm

# Update flatpak packages
echo "[3/6] Updating flatpak packages..."
flatpak update -y

# Remove orphaned packages (root needed)
echo "[4/6] Checking for orphaned packages..."
orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    echo "Removing orphaned packages: $orphans"
    sudo pacman -Rns --noconfirm $orphans
else
    echo "No orphaned packages found."
fi

# Clear old package cache but keep the latest one (root needed)
echo "[5/6] Cleaning pacman cache..."
sudo paccache -ruk0

# Clean yay cache
echo "[6/6] Cleaning yay cache..."
yay -Scc --noconfirm

# Remove unused flatpak runtimes
echo "[7/6] Cleaning unused flatpak runtimes..."
flatpak uninstall --unused -y

echo "=== System cleanup completed successfully! ==="

