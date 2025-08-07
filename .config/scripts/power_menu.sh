#!/bin/bash

choice=$(printf "⏻ Power Off\n Reboot\n Suspend\n Hibernate\n Lock" | \
  wofi --dmenu --cache-file /dev/null --width 300 --height 270 --hide-scroll --prompt "Power Menu")

case "$choice" in
  "⏻ Power Off") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Suspend") systemctl suspend ;;
  " Hibernate") systemctl hibernate ;;
  " Lock") loginctl lock-session ;;
esac
