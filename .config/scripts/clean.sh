#!/bin/bash
set -e

sudo pacman -Syu --noconfirm
yay -Syu --noconfirm
flatpak update -y

orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    sudo pacman -Rns --noconfirm $orphans
fi

sudo paccache -ruk0
yay -Scc --noconfirm
flatpak uninstall --unused -y
