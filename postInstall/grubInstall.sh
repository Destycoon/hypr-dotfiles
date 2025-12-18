#!/bin/bash

set -e

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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info "Configuration de GRUB..."

# Vérifier si GRUB est installé
if ! command -v grub-mkconfig >/dev/null 2>&1; then
    print_error "GRUB n'est pas installé"
    exit 1
fi

# Détecter le système UEFI ou BIOS
if [ -d /sys/firmware/efi ]; then
    print_info "Système UEFI détecté"
    UEFI=true
else
    print_info "Système BIOS détecté"
    UEFI=false
fi

# Configuration du fichier GRUB
GRUB_CONFIG="/etc/default/grub"

print_info "Sauvegarde de la configuration actuelle..."
sudo cp "$GRUB_CONFIG" "$GRUB_CONFIG.backup"

# Appliquer les configurations recommandées
print_info "Application des paramètres GRUB..."

# Désactiver le timeout si vous voulez un boot direct
# sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$GRUB_CONFIG"

# Ajouter des paramètres du noyau pour de meilleures performances
if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CONFIG"; then
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' | sudo tee -a "$GRUB_CONFIG"
else
    print_info "GRUB_CMDLINE_LINUX_DEFAULT déjà configuré"
fi

# Régénérer la configuration GRUB
print_info "Régénération de la configuration GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Installation de GRUB sur le disque (seulement si nécessaire)
print_warning "Voulez-vous réinstaller GRUB sur le disque? (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Lister les disques disponibles
    print_info "Disques disponibles:"
    lsblk -dno NAME,SIZE | grep -v loop
    
    print_info "Entrez le disque cible (ex: /dev/sda):"
    read -r disk
    
    if [ -b "$disk" ]; then
        if [ "$UEFI" = true ]; then
            print_info "Installation de GRUB en mode UEFI sur $disk..."
            sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB "$disk"
        else
            print_info "Installation de GRUB en mode BIOS sur $disk..."
            sudo grub-install --target=i386-pc "$disk"
        fi
        
        print_info "Régénération de la configuration..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        print_success "GRUB installé avec succès"
    else
        print_error "Disque invalide: $disk"
        exit 1
    fi
else
    print_info "Installation de GRUB ignorée"
fi

print_success "Configuration de GRUB terminée"

