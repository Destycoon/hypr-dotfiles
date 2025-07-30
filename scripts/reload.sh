#!/bin/bash

killall waybar
killall hyprpaper
sleep 1
waybar &
hyprpaper &

