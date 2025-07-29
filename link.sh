#!/bin/bash

# Chemin vers le dossier contenant tes dotfiles
DOTFILES_DIR=~/hypr-dotfiles
CONFIG_DIR=~/.config

FILES=("hypr" "kitty" "waybar" "fastfetch" "wofi" "cava")

echo "Linking dotfiles from $DOTFILES_DIR to $CONFIG_DIR..."

for folder in "${FILES[@]}"; do
    src="$DOTFILES_DIR/$folder"
    dest="$CONFIG_DIR/$folder"

    # ➤ Corrigé : espace après [ et avant ]
    if [ ! -e "$src" ]; then 
        echo "Copying $dest to $src (doesn't exist in dotfiles)"
        cp -r "$dest" "$DOTFILES_DIR"
    else
        if [ -L "$dest" ]; then
            echo "Removing existing symlink: $dest"
            rm "$dest"
        elif [ -d "$dest" ]; then
            echo "Removing existing directory: $dest"
            rm -rf "$dest"
        fi

        echo "Linking $src -> $dest"
        ln -s "$src" "$dest"
    fi
done

echo "All done!"
