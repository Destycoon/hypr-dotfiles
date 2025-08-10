#!/bin/bash

killall waybar
killall wofi
sleep 0.2
waybar &

hyprctl reload
