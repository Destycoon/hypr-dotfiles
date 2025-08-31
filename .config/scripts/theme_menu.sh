#!/bin/bash

# Répertoires
THEME_DIR="$HOME/.config/theme"

# Sélection du thème avec Wofi
choice=$(find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | \
    wofi --dmenu --cache-file /dev/null --width 300 --height 250 --hide-scroll --location=0 --prompt "Choisir un thème")

[ -z "$choice" ] && notify-send "Annulé" "Aucun thème sélectionné" && exit 1

THEME="$choice"
THEME_PATH="$THEME_DIR/$THEME"
WALLPAPER=$(find "$THEME_PATH" -maxdepth 1 -iname "wallpaper.*" | head -n1)

# Appliquer le fond d’écran
if [ -f "$WALLPAPER" ]; then
  swww img "$WALLPAPER" --transition-type=wave --transition-fps=60 --transition-step=255 --transition-duration=1.5

  # Générer les couleurs Pywal
  wal -i "$WALLPAPER" -n -q

  notify-send "Thème appliqué" "$THEME"

  rm -f "$HOME/.cache/wal/wallpaper.*"
  cp "$WALLPAPER" "$HOME/.cache/wal/wallpaper.png"

  SQUARE_IMG=$(find "$THEME_PATH/images" -iname "square_wallpaper.*" | head -n1)
  if [ -f "$SQUARE_IMG" ]; then
    
    cp "$SQUARE_IMG" "$HOME/.cache/wal/square_wallpaper.png"
    echo "Hyprlock image appliquée"
  else
    echo "Aucune image square_wallpaper trouvée pour Hyprlock"
  fi
else
  notify-send "Erreur" "Aucun wallpaper trouvé dans $THEME_PATH"
  exit 1
fi
# Rechargement
bash "$HOME/.config/scripts/reload.sh"
