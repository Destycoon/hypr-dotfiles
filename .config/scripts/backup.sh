#!/bin/bash

# Script de sauvegarde de la configuration Hyprland
# Crée une archive timestampée de votre configuration

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Configuration
BACKUP_DIR="$HOME/hypr-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="hyprland_backup_$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Créer le répertoire de backup
mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_PATH"

print_info "Sauvegarde de la configuration Hyprland..."
print_info "Destination: $BACKUP_PATH"

# Liste des configurations à sauvegarder
CONFIGS=(
    "$HOME/.config/hypr"
    "$HOME/.config/fish"
    "$HOME/.config/ghostty"
    "$HOME/.config/quickshell"
    "$HOME/.config/swaync"
    "$HOME/.config/starship.toml"
)

# Copier chaque configuration
for config in "${CONFIGS[@]}"; do
    if [ -e "$config" ]; then
        config_name=$(basename "$config")
        print_info "Sauvegarde de $config_name..."
        cp -r "$config" "$BACKUP_PATH/"
    fi
done

# Créer un fichier d'informations système
cat > "$BACKUP_PATH/system_info.txt" << EOF
Sauvegarde créée le: $(date)
Hostname: $(hostname)
Kernel: $(uname -r)
GPU: $(lspci | grep -E "VGA|3D" | cut -d':' -f3)
Hyprland version: $(hyprctl version | head -1)
EOF

# Créer une archive tar.gz
print_info "Création de l'archive..."
cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

# Taille de l'archive
SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)

print_success "Sauvegarde créée: $BACKUP_DIR/${BACKUP_NAME}.tar.gz ($SIZE)"
print_info "Pour restaurer: tar -xzf ${BACKUP_NAME}.tar.gz -C ~/"

# Nettoyer les anciennes sauvegardes (garder les 5 dernières)
print_info "Nettoyage des anciennes sauvegardes..."
cd "$BACKUP_DIR"
ls -t hyprland_backup_*.tar.gz | tail -n +6 | xargs -r rm
print_success "Sauvegardes anciennes supprimées (conservées: 5 dernières)"

echo ""
print_success "Sauvegarde terminée avec succès!"
