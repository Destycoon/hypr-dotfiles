#!/bin/bash

# Script de déploiement robuste pour la configuration Hyprland
# Crée des liens symboliques depuis le repo vers ~/.config

set -e

# Déterminer le chemin du repo de manière robuste
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SRC_CONFIG="$REPO_DIR"
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

print_info "Déploiement depuis: $SRC_CONFIG"
print_info "Vers: $DEST_CONFIG"

# Créer le répertoire .config s'il n'existe pas
mkdir -p "$DEST_CONFIG"

# Créer des liens symboliques pour chaque élément
for item in "$SRC_CONFIG"/*; do
  name=$(basename "$item")
  target="$DEST_CONFIG/$name"
  
  # Ignorer certains fichiers/dossiers
  if [[ "$name" == ".git" ]] || [[ "$name" == "README.md" ]]; then
    continue
  fi

  # Supprimer le lien/fichier existant s'il est présent
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink -f "$target")" == "$(realpath "$item")" ]; then
      print_success "✓ $name déjà lié correctement"
      continue
    fi
    
    print_warning "Suppression de l'ancienne configuration: $name"
    rm -rf "$target"
  fi

  # Créer le lien symbolique
  ln -s "$item" "$target"
  print_success "✓ $name lié"
done

print_success "Déploiement terminé!"

# Optionally reload config if needed
if [ -f "$HOME/.config/scripts/reload.sh" ]; then
  print_info "Rechargement de la configuration..."
  bash "$HOME/.config/scripts/reload.sh" &
fi
