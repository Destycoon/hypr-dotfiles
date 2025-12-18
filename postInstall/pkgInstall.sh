#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PACMAN="$SCRIPT_DIR/pacman.txt"
YAY="$SCRIPT_DIR/yay.txt"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

#func install yay if not installed
install_yay() {
    if ! command -v yay &>/dev/null; then
        print_info "Installation de yay..."
        cd /tmp
        git clone "https://aur.archlinux.org/yay.git"
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
        print_success "Yay installé avec succès"
    else
        print_success "Yay est déjà installé"
    fi
}

#func Install Pacman PKG
install_pacman_pkg() {
    print_info "Installation des paquets Pacman..."
    local failed_pkgs=()
    
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        # Ignorer les commentaires et lignes vides
        [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
        
        # Supprimer les espaces
        pkg=$(echo "$pkg" | xargs)
        [[ -z "$pkg" ]] && continue
        
        if pacman -Qi "$pkg" &> /dev/null; then
            print_success "$pkg est déjà installé"
        else
            print_info "Installation de $pkg..."
            if sudo pacman -S --noconfirm --needed "$pkg" 2>&1 | tee /tmp/pacman_install.log; then
                print_success "$pkg installé"
            else
                print_error "Échec de l'installation de $pkg"
                failed_pkgs+=("$pkg")
            fi
        fi
    done < "$PACMAN"
    
    if [ ${#failed_pkgs[@]} -gt 0 ]; then
        print_warning "Paquets non installés: ${failed_pkgs[*]}"
    fi
}

#func Install yay package
install_yay_pkg() {
    print_info "Installation des paquets AUR..."
    local failed_pkgs=()
    
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        # Ignorer les commentaires et lignes vides
        [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
        
        # Supprimer les espaces
        pkg=$(echo "$pkg" | xargs)
        [[ -z "$pkg" ]] && continue
        
        if pacman -Qi "$pkg" &> /dev/null; then
            print_success "$pkg est déjà installé"
        else
            print_info "Installation de $pkg..."
            if yay -S --noconfirm --needed "$pkg" 2>&1 | tee /tmp/yay_install.log; then
                print_success "$pkg installé"
            else
                print_error "Échec de l'installation de $pkg"
                failed_pkgs+=("$pkg")
            fi
        fi
    done < "$YAY"
    
    if [ ${#failed_pkgs[@]} -gt 0 ]; then
        print_warning "Paquets AUR non installés: ${failed_pkgs[*]}"
    fi
}

# Mise à jour du système
print_info "Mise à jour du système..."
sudo pacman -Syu --noconfirm

# Installation des paquets
install_yay
install_pacman_pkg
install_yay_pkg

# Configuration de Flatpak
if ! flatpak remote-list | grep -q "flathub"; then
    print_info "Configuration de Flatpak..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    print_success "Flatpak configuré"
else
    print_success "Flatpak est déjà configuré"
fi

# Activer les services
print_info "Activation des services système..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sddm
sudo systemctl enable power-profiles-daemon

print_success "Tous les paquets sont installés!"