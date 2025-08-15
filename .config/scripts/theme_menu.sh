#!/bin/bash

# Répertoires cibles
THEME_DIR="$HOME/.config/theme"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
WAYBAR_DEST="$HOME/.config/waybar"
WOFI_DEST="$HOME/.config/wofi"
HYPRLAND_DEST="$HOME/.config/hypr"
FASTFETCH_DEST="$HOME/.config/fastfetch"
KITTY_DEST="$HOME/.config/kitty"

# Sélection du thème
choice=$(find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | wofi --dmenu --cache-file /dev/null --width 300 --height 250 --hide-scroll --location=0 --prompt "Choisir un thème")

[ -z "$choice" ] && notify-send "Annulé" "Aucun thème sélectionné" && exit 1

THEME="$choice"

THEME_PATH="$THEME_DIR/$THEME"
WALLPAPER=$(find "$THEME_PATH" -maxdepth 1 -iname "wallpaper.*" | head -n1)

# Appliquer le fond d’écran
if [ -f "$WALLPAPER" ]; then
  swww img "$WALLPAPER" --transition-type=wipe --transition-fps=60 --transition-step=255 --transition-duration=1.5

  notify-send "Thème appliqué : $THEME"
else
  notify-send "Erreur" "Aucun wallpaper trouvé dans $THEME_PATH"
  exit 1
fi

# Fonction pour copier un fichier si présent
copy_if_exists() {
  SRC="$1"
  DEST="$2"
  NAME="$3"

  mkdir -p "$(dirname "$DEST")"

  if [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    echo "$NAME appliqué"
  else
    echo  "$NAME non trouvé"
  fi
}

###########
# COPIES  #
###########

# Waybar
copy_if_exists "$THEME_PATH/waybar/style.css" "$WAYBAR_DEST/style.css" "Waybar"

# Wofi
copy_if_exists "$THEME_PATH/wofi/style.css" "$WOFI_DEST/style.css" "Wofi"

# Hyprland
copy_if_exists "$THEME_PATH/hypr/hyprlock.conf" "$HYPRLAND_DEST/hyprlock.conf" "Hyprlock"
copy_if_exists "$THEME_PATH/hypr/hyprland.conf" "$HYPRLAND_DEST/hyprland.conf" "Hyprland"

# Fastfetch
copy_if_exists "$THEME_PATH/fastfetch/config.jsonc" "$FASTFETCH_DEST/config.jsonc" "Fastfetch config"
copy_if_exists "$THEME_PATH/fastfetch/logo.txt" "$FASTFETCH_DEST/logo.txt" "Fastfetch logo"

# Kitty
copy_if_exists "$THEME_PATH/kitty/theme.conf" "$KITTY_DEST/theme.conf" "Kitty theme"

# Rechargement
bash "$HOME/.config/scripts/reload.sh"
