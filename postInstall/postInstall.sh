#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Install packages
bash "$SCRIPT_DIR/pkgInstall.sh"

# Deploy configs
bash "$SCRIPT_DIR/../.config/scripts/deploy.sh"

read -p  "Install grub theme ? (y/n): " answer

answer=${answer,,}

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
    echo "installing grub theme..."
    sudo pacman -S grub
    bash "$SCRIPT_DIR/grubInstall.sh"
else 
    echo "continue without grub"
fi

# Create default folders
for dir in Documents Images Musique Téléchargements Vidéos; do
    mkdir -p "$HOME/$dir"
done

if command -v zsh >/dev/null 2>&1; then
    chsh -s "$(which zsh)"
fi

if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload || true
fi
