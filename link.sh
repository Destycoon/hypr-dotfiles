#!/bin/bash

# Chemin vers le dossier contenant tes dotfiles
DOTFILES_DIR=~/hypr-dotfiles
CONFIG_DIR=~/.config


FILES=("hypr" "kitty" "waybar")

echo "🔗 Linking dotfiles from $DOTFILES_DIR to $CONFIG_DIR..."

for folder in "${FILES[@]}"; do
    src="$DOTFILES_DIR/$folder"
    dest="$CONFIG_DIR/$folder"

    if [ -L "$dest" ]; then
        echo "🔁 Removing existing symlink: $dest"
        rm "$dest"
    elif [ -d "$dest" ]; then
        echo "🗑️ Removing existing directory: $dest"
        rm -rf "$dest"
    fi

    echo "✅ Linking $src -> $dest"
    ln -s "$src" "$dest"
done

echo "🎉 All done!"
