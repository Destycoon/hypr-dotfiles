#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

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

print_info "======================================="
print_info "Post-Installation Hyprland Dotfiles"
print_info "======================================="

# Vérifier qu'on est dans le bon répertoire
if [ ! -d "$REPO_DIR/.config" ]; then
    print_error ".config non trouvé dans $REPO_DIR"
    print_error "Exécutez ce script depuis le dossier postInstall du repo"
    exit 1
fi

# Étape 1: Installation de yay et des paquets
print_info "Étape 1/2: Installation de yay et des paquets..."
bash "$SCRIPT_DIR/pkgInstall.sh"
print_success "Paquets installés"

# Étape 2: Déploiement de la configuration
print_info "Étape 2/3: Déploiement de la configuration..."
if [ -f "$REPO_DIR/.config/scripts/deploy.sh" ]; then
    bash "$REPO_DIR/.config/scripts/deploy.sh"
    print_success "Configuration déployée"
else
    print_error "Script deploy.sh non trouvé dans .config/scripts/"
    exit 1
fi

# Étape 3: Configuration de Fish comme shell par défaut
print_info "Étape 3/3: Configuration de Fish comme shell par défaut..."
if command -v fish >/dev/null 2>&1; then
    if [ "$SHELL" != "$(which fish)" ]; then
        chsh -s "$(which fish)"
        print_success "Fish configuré comme shell par défaut"
    else
        print_success "Fish est déjà le shell par défaut"
    fi
else
    print_error "Fish n'est pas installé"
fi

print_success "======================================="
print_success "Installation terminée avec succès!"
print_success "======================================="
print_info ""
print_info "Redémarrez votre session pour appliquer les changements"
print_info ""
