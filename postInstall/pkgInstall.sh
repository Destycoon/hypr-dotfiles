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

# Fonction pour extraire les paquets du fichier (ignorer commentaires et lignes vides)
extract_packages() {
    local file="$1"
    grep -v '^[[:space:]]*#' "$file" | grep -v '^[[:space:]]*$' | tr '\n' ' '
}

# Installation de yay si non installé
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

# Installation des paquets Pacman en une seule commande
install_pacman_pkg() {
    print_info "Installation des paquets Pacman..."
    
    # Extraire tous les paquets du fichier
    local packages=$(extract_packages "$PACMAN")
    
    if [ -z "$packages" ]; then
        print_warning "Aucun paquet à installer depuis pacman.txt"
        return
    fi
    
    print_info "Paquets à installer: $packages"
    
    # Installer tous les paquets en une seule commande
    if sudo pacman -S --noconfirm --needed $packages; then
        print_success "Tous les paquets Pacman ont été installés avec succès"
    else
        print_error "Certains paquets n'ont pas pu être installés"
        print_warning "Vous pouvez vérifier manuellement les erreurs ci-dessus"
    fi
}

# Installation des paquets AUR en une seule commande
install_yay_pkg() {
    print_info "Installation des paquets AUR..."
    
    # Extraire tous les paquets du fichier
    local packages=$(extract_packages "$YAY")
    
    if [ -z "$packages" ]; then
        print_warning "Aucun paquet à installer depuis yay.txt"
        return
    fi
    
    print_info "Paquets AUR à installer: $packages"
    
    # Installer tous les paquets en une seule commande
    if yay -S --noconfirm --needed $packages; then
        print_success "Tous les paquets AUR ont été installés avec succès"
    else
        print_error "Certains paquets AUR n'ont pas pu être installés"
        print_warning "Vous pouvez vérifier manuellement les erreurs ci-dessus"
    fi
}

# Mise à jour du système
print_info "Mise à jour du système..."
sudo pacman -Syu --noconfirm

# Détection et installation du matériel spécifique
if [ -f "$SCRIPT_DIR/detectHardware.sh" ]; then
    print_info "Détection du matériel..."
    bash "$SCRIPT_DIR/detectHardware.sh"
else
    print_warning "Script de détection matérielle non trouvé, passage à l'installation standard"
fi

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