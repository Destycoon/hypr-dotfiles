#!/bin/bash

killall waybar   >/dev/null 2>&1
killall wofi     >/dev/null 2>&1
killall hyprpaper >/dev/null 2>&1
killall qs

sleep 0.5

waybar >/dev/null 2>&1 &
hyprpaper >/dev/null 2>&1 &
qs -p ~/.config/quickshell/bar
hyprctl reload >/dev/null 2>&1
