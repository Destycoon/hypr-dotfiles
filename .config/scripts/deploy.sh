#!/bin/bash

# Script de déploiement de la configuration Hyprland
# Crée des liens symboliques depuis le repo vers ~/.config

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DEST_CONFIG="$HOME/.config"

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

print_info "Déploiement de la configuration..."
print_info "Source: $REPO_DIR"
print_info "Destination: $DEST_CONFIG"

# Créer .config si nécessaire
mkdir -p "$DEST_CONFIG"

# Créer des liens symboliques pour chaque élément
for item in "$REPO_DIR"/*; do
  name=$(basename "$item")
  target="$DEST_CONFIG/$name"
  
  # Ignorer certains fichiers/dossiers
  if [[ "$name" == ".git" ]] || [[ "$name" == "README.md" ]]; then
    continue
  fi

  # Si le lien existe déjà et pointe vers le bon endroit
  if [ -L "$target" ] && [ "$(readlink -f "$target")" == "$(realpath "$item")" ]; then
    print_success "✓ $name déjà lié"
    continue
  fi
  
  # Supprimer l'ancien fichier/lien s'il existe
  if [ -e "$target" ] || [ -L "$target" ]; then
    print_warning "Suppression de: $name"
    rm -rf "$target"
  fi

  # Créer le lien symbolique
  ln -s "$item" "$target"
  print_success "✓ $name lié"
done

print_success "Déploiement terminé!"
