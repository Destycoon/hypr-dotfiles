#!/bin/bash

killall waybar   >/dev/null 2>&1
killall wofi     >/dev/null 2>&1
killall hyprpaper >/dev/null 2>&1

sleep 0.5

waybar >/dev/null 2>&1 &
hyprpaper >/dev/null 2>&1 &

hyprctl reload >/dev/null 2>&1
