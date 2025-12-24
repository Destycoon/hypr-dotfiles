#!/bin/bash

# Script de configuration automatique des moniteurs pour Hyprland
# Ce script détecte les écrans connectés et génère une configuration appropriée

MONITORS_CONF="$HOME/.config/hypr/monitors.conf"

# Créer le fichier de configuration des moniteurs
cat > "$MONITORS_CONF" << 'EOF'
# Configuration automatique des moniteurs
# Ce fichier est généré automatiquement par setupMonitors.sh

# Configuration par défaut - s'adapte automatiquement à tous les écrans
monitor=,preferred,auto,1

# Fallback si aucun écran n'est détecté
# monitor=,highres,auto,1
EOF

echo "Configuration des moniteurs créée dans $MONITORS_CONF"
