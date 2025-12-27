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
failed_packages=()
while IFS= read -r pkg; do
    # Ignorer les commentaires et lignes vides
    [[ "${pkg:0:1}" == "#" ]] && continue
    [[ -z "$pkg" ]] && continue
    
    print_info "Installation de $pkg..."
    if sudo pacman -S --noconfirm --needed "$pkg"; then
        print_success "$pkg installé"
    else
        print_error "Échec de l'installation de $pkg"
        failed_packages+=("$pkg")
    fi
done < "$PACMAN_FILE"

if [ ${#failed_packages[@]} -eq 0 ]; then
    print_success "Tous les paquets Pacman installés avec succès"
else
    print_warning "Paquets Pacman en échec: ${failed_packages[*]}"
fi

# 3. Installer les paquets AUR
print_info "Installation des paquets AUR..."
failed_packages=()
while IFS= read -r pkg; do
    # Ignorer les commentaires et lignes vides
    [[ "${pkg:0:1}" == "#" ]] && continue
    [[ -z "$pkg" ]] && continue
    
    print_info "Installation de $pkg..."
    if yay -S --noconfirm --needed "$pkg"; then
        print_success "$pkg installé"
    else
        print_error "Échec de l'installation de $pkg"
        failed_packages+=("$pkg")
    fi
done < "$YAY_FILE"

if [ ${#failed_packages[@]} -eq 0 ]; then
    print_success "Tous les paquets AUR installés avec succès"
else
    print_warning "Paquets AUR en échec: ${failed_packages[*]}"
fi

print_success "Installation des paquets terminée!"