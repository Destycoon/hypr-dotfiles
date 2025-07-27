#!/bin/bash

bars=$(cava -p ~/.config/waybar/cava_config | tail -n 1)
echo "{\"text\": \"$bars\"}"
