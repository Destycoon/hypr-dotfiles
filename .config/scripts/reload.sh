#!/bin/bash

killall wofi     >/dev/null 2>&1
killall hyprpaper >/dev/null 2>&1
killall qs

sleep 0.5

hyprpaper >/dev/null 2>&1 &
qs >/dev/null 2>&1 & 
hyprctl reload >/dev/null 2>&1
