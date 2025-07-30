#!/bin/bash

THEME_DIR="$HOME/hypr-dotfiles/theme"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
WAYBAR_DEST="$HOME/.config/waybar"
WOFI_DEST="$HOME/.config/wofi"

# Liste des thèmes avec emoji (assure-toi que les noms sont corrects !)
choice=$(printf "🎨 Blue\n🌙 Black" | \
  wofi --dmenu --cache-file /dev/null --width 300 --height 250 --hide-scroll --prompt "Choisir un thème")

# Convertir le choix en nom de dossier (⚠️ attention aux noms exacts)
case "$choice" in
  "🎨 Blue") THEME="blue" ;;
  "🌙 Black") THEME="black" ;;
  *) notify-send "Annulé" "Aucun thème sélectionné"; exit 1 ;;
esac

THEME_PATH="$THEME_DIR/$THEME"
WALLPAPER=$(find "$THEME_PATH" -maxdepth 1 -iname "wallpaper.*" | head -n1)

# Vérifie que le fond d'écran existe
if [ -f "$WALLPAPER" ]; then
  # Vide le fichier de config
  > "$HYPRPAPER_CONF"

  # Ajoute preload
  echo "preload = $WALLPAPER" >> "$HYPRPAPER_CONF"

  # Ajoute pour chaque moniteur détecté
  hyprctl monitors | grep "Monitor" | awk '{print $2}' | while read -r MON; do
    echo "wallpaper = $MON,$WALLPAPER" >> "$HYPRPAPER_CONF"
  done

  notify-send "🎨 Thème appliqué : $THEME"
else
  notify-send "Erreur" "Aucun wallpaper trouvé dans $THEME_PATH"
  exit 1
fi

if [ -f "$THEME_PATH/waybar/style.css" ]; then
  cp "$THEME_PATH/waybar/style.css" "$WAYBAR_DEST/style.css"
fi

if [ -f "$THEME_PATH/wofi/style.css" ]; then
  cp "$THEME_PATH/wofi/style.css" "$WOFI_DEST/style.css"
fi


bash ~/hypr-dotfiles/scripts/./reload.sh