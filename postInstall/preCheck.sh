#!/bin/bash

# Script de vérification avant installation
# Vérifie les prérequis et affiche les informations système

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_header() {
    echo -e "${CYAN}==================================="
    echo -e "$1"
    echo -e "===================================${NC}"
}

print_header "Vérification du Système"

# Vérifier qu'on est sur Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "Ce script est conçu pour Arch Linux"
    exit 1
else
    print_success "Arch Linux détecté"
fi

# Vérifier la connexion Internet
print_info "Vérification de la connexion Internet..."
if ping -c 1 archlinux.org &> /dev/null; then
    print_success "Connexion Internet active"
else
    print_error "Pas de connexion Internet - requis pour l'installation"
    exit 1
fi

# Afficher les informations système
print_header "Informations Système"

# CPU
echo -e "${BLUE}CPU:${NC}"
lscpu | grep "Model name" | cut -d':' -f2 | xargs

# RAM
echo -e "${BLUE}RAM:${NC}"
free -h | grep "Mem:" | awk '{print $2}'

# GPU
echo -e "${BLUE}GPU:${NC}"
lspci | grep -E "VGA|3D" | cut -d':' -f3 | xargs

# Écrans connectés
echo -e "${BLUE}Affichage:${NC}"
if command -v xrandr &> /dev/null && [ -n "$DISPLAY" ]; then
    xrandr | grep " connected" | awk '{print $1}' || echo "Détection impossible (pas en mode graphique)"
else
    echo "Détection impossible (pas en mode graphique)"
fi

# Disque
echo -e "${BLUE}Espace disque disponible:${NC}"
df -h / | tail -1 | awk '{print $4 " disponible sur " $2}'

# Vérifier l'espace disque (minimum 10GB recommandé)
available_space=$(df / | tail -1 | awk '{print $4}')
if [ "$available_space" -lt 10485760 ]; then
    print_warning "Moins de 10 GB d'espace disque disponible"
else
    print_success "Espace disque suffisant"
fi

# Vérifications des prérequis
print_header "Vérification des Prérequis"

# Pacman
if command -v pacman &> /dev/null; then
    print_success "Pacman installé"
else
    print_error "Pacman non trouvé"
    exit 1
fi

# Git
if command -v git &> /dev/null; then
    print_success "Git installé"
else
    print_warning "Git non installé - sera installé pendant le processus"
fi

# Base-devel
if pacman -Qg base-devel &> /dev/null; then
    print_success "base-devel installé"
else
    print_warning "base-devel non installé - requis pour compiler les paquets AUR"
    print_info "Installez-le avec: sudo pacman -S base-devel"
fi

# Sudo
if command -v sudo &> /dev/null; then
    print_success "sudo installé"
else
    print_error "sudo requis mais non installé"
    exit 1
fi

print_header "Détection du Matériel"

# WiFi
if lspci | grep -iq "network\|wireless\|wi-fi"; then
    print_success "Carte WiFi détectée"
else
    print_info "Pas de carte WiFi détectée (normal pour un PC de bureau)"
fi

# Bluetooth
if lsusb | grep -iq "bluetooth" || lspci | grep -iq "bluetooth"; then
    print_success "Bluetooth détecté"
else
    print_info "Pas de Bluetooth détecté"
fi

# Type de GPU
if lspci | grep -E "VGA|3D" | grep -iq "intel"; then
    print_success "GPU Intel détecté - pilotes Intel seront installés"
fi

if lspci | grep -E "VGA|3D" | grep -iq "amd\|radeon"; then
    print_success "GPU AMD détecté - pilotes AMD seront installés"
fi

if lspci | grep -E "VGA|3D" | grep -iq "nvidia"; then
    print_success "GPU NVIDIA détecté - pilotes NVIDIA seront installés"
fi

print_header "Résumé"

echo ""
print_info "Le système est prêt pour l'installation"
print_warning "L'installation va:"
echo "  - Installer ~150+ paquets"
echo "  - Télécharger plusieurs GB de données"
echo "  - Prendre environ 30-60 minutes selon votre connexion"
echo "  - Configurer automatiquement votre environnement Hyprland"
echo ""

read -p "Voulez-vous continuer avec l'installation? [o/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[OoYy]$ ]]; then
    print_success "Lancement de l'installation..."
    exec "$(dirname "$0")/postInstall.sh"
else
    print_info "Installation annulée"
    exit 0
fi
