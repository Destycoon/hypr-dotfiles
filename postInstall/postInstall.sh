#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Install packages
bash "$SCRIPT_DIR/pkgInstall.sh"

# Deploy configs
bash "$SCRIPT_DIR/../.config/scripts/deploy.sh"

# Create default folders
for dir in Documents Pictures Music Downloads Videos; do
    mkdir -p "$HOME/$dir"
done

# Reload Hyprland
hyprctl reload
