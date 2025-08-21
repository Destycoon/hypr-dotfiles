#!/bin/bash

# Chemins
SOURCE="$HOME/hypr-dotfiles/"
DEST="$HOME/"

# Fichiers ou dossiers à exclure
EXCLUDES=(
  ".git"
  "pkglist.txt"
  "README.md"
  "postInstall"
)

# Construction des arguments d'exclusion
EXCLUDE_ARGS=()
for item in "${EXCLUDES[@]}"; do
  EXCLUDE_ARGS+=("--exclude=$item")
done

# Exécution de rsync
rsync -avh --update "${EXCLUDE_ARGS[@]}" "$SOURCE" "$DEST"

bash "$HOME/.config/scripts/reload.sh" &