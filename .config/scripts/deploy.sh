#!/bin/bash

SRC_CONFIG="$HOME/hypr-dotfiles/.config"
DEST_CONFIG="$HOME/.config"

# Create symlinks for each directory in hypr-dotfiles/.config
for item in "$SRC_CONFIG"/*; do
  name=$(basename "$item")
  target="$DEST_CONFIG/$name"

  # Remove existing file/directory/symlink if present
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -s "$item" "$target"
done

# Optionally reload config if needed
bash "$HOME/.config/scripts/reload.sh" &
