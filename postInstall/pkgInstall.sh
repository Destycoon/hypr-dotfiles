#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PACMAN_FILE="$SCRIPT_DIR/pacman.txt"
YAY_FILE="$SCRIPT_DIR/yay.txt"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Extraire les paquets du fichier (ignorer commentaires et lignes vides)
extract_packages() {
    local file="$1"
    grep -v '^[[:space:]]*#' "$file" | grep -v '^[[:space:]]*$' | tr '\n' ' '
}

# 1. Installer yay si nécessaire
print_info "Vérification de yay..."
if ! command -v yay &>/dev/null; then
    print_info "Installation de yay..."
    cd /tmp
    git clone "https://aur.archlinux.org/yay.git"
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    print_success "Yay installé"
else
    print_success "Yay déjà installé"
fi

# 2. Installer les paquets Pacman
print_info "Installation des paquets Pacman..."
packages=$(extract_packages "$PACMAN_FILE")
if [ -n "$packages" ]; then
    if sudo pacman -S --noconfirm --needed $packages; then
        print_success "Paquets Pacman installés"
    else
        print_warning "Certains paquets Pacman n'ont pas pu être installés (on continue)"
    fi
else
    print_warning "Aucun paquet Pacman à installer"
fi

# 3. Installer les paquets AUR
print_info "Installation des paquets AUR..."
packages=$(extract_packages "$YAY_FILE")
if [ -n "$packages" ]; then
    if yay -S --noconfirm --needed $packages; then
        print_success "Paquets AUR installés"
    else
        print_warning "Certains paquets AUR n'ont pas pu être installés"
    fi
else
    print_warning "Aucun paquet AUR à installer"
fi

print_success "Installation des paquets terminée!"