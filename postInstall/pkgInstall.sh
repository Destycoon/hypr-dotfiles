#!/bin/bash

PACMAN="$HOME/hypr-dotfiles/postInstall/pacman.txt"
YAY="$HOME/hypr-dotfiles/postInstall/yay.txt"

#func install yay if not installed
install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "Installation yay"
        mkdir -p "$HOME/yay"
        git clone "https://aur.archlinux.org/yay.git"
        cd "$HOME/yay"
        makepkg -si --noconfirm
        cd "../"
        rm -rf "yay"
    else
        echo "Yay already installed"
    fi
}

#func Install Pacman PKG
install_pacman_pkg() {
    echo "Pacman Packages Installation..."
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
        if pacman -Qi "$pkg" &> /dev/null; then
            echo "$pkg already installed"
        else
            echo "Installation de $pkg"
            sudo pacman -S --noconfirm --needed "$pkg"
        fi
    done < "$PACMAN"
}

#func Install yay package
install_yay_pkg() {
    echo "Yay Packages Installation..."
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        [[ -z "$pkg" || "pkg" =~ ^# ]] && continue
        if pacman -Qi "$pkg" &> /dev/null; then
            echo "$pkg already installed"
        else
            echo "Installation de $pkg"
            yay -S --noconfirm --needed "$pkg"
        fi
    done < "$YAY"
}

echo "Packages Update"
sudo pacman -Syu --noconfirm

install_yay
install_pacman_pkg
install_yay_pkg

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak installed and configured"

echo "All packages installed"