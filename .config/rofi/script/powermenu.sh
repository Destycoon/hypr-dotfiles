#!/bin/bash

# Icônes avec Font Awesome (otf-font-awesome doit être installé)
shutdown="  Éteindre"
reboot="  Redémarrer"
lock="  Verrouiller"
suspend="  Veille"
logout="  Déconnexion"

# Menu Rofi
selected=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" \
    | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/theme/powermenu.rasi)

case $selected in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$lock") hyprlock ;; # ou ton verrouilleur d’écran
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit ;;
esac
