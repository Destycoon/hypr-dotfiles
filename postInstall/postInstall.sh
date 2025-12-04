#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Install packages
bash "$SCRIPT_DIR/pkgInstall.sh"

# Deploy configs
bash "$SCRIPT_DIR/../.config/scripts/deploy.sh"


# Create default folders
for dir in Documents Images Musique Téléchargements Vidéos; do
    mkdir -p "$HOME/$dir"
done

if command -v fish >/dev/null 2>&1; then
    chsh -s "$(which fish)"
fi

if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload || true
fi
