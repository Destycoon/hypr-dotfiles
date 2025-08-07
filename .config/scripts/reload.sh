#!/bin/bash

killall waybar
killall hyprpaper
killall wofi
sleep 0.2
waybar &
hyprpaper &

