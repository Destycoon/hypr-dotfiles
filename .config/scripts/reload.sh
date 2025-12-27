#!/bin/bash

killall wofi     >/dev/null 2>&1
killall hyprpaper >/dev/null 2>&1
killall qs
killall awww-daemon
sleep 0.5

hyprpaper >/dev/null 2>&1 &
QT_QPA_PLATFORMTHEME=gtk3 qs >/dev/null 2>&1 & 
hyprctl reload >/dev/null 2>&1
awww-daemon &
