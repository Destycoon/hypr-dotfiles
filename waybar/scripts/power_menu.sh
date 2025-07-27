#!/bin/bash

choice=$(printf "⏻ Éteindre\n Redémarrer\n Suspendre\n Hiberner\n Verrouiller\n Quitter session" | \
  wofi --dmenu --cache-file /dev/null --width 300 --height 250 --hide-scroll --prompt "Énergie")

case "$choice" in
  "⏻ Éteindre") systemctl poweroff ;;
  " Redémarrer") systemctl reboot ;;
  " Suspendre") systemctl suspend ;;
  " Hiberner") systemctl hibernate ;;
  " Verrouiller") loginctl lock-session ;;
  " Quitter session") loginctl terminate-session "$XDG_SESSION_ID" ;;
esac
