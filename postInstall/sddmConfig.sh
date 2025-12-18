#!/bin/bash

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

print_info "Configuration de SDDM pour résolution automatique..."

# Créer le fichier de configuration SDDM
sudo mkdir -p /etc/sddm.conf.d

# Configuration pour Wayland et résolution auto
sudo tee /etc/sddm.conf.d/autologin.conf > /dev/null << 'EOF'
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_FORCE_DPI=physical

[Wayland]
CompositorCommand=Hyprland

[X11]
# Si vous utilisez X11, décommentez ces lignes :
# ServerArguments=-nolisten tcp -dpi 96
EOF

print_success "Configuration SDDM créée"

# Créer un script Xsetup pour la résolution auto (fallback X11)
sudo tee /usr/share/sddm/scripts/Xsetup > /dev/null << 'EOF'
#!/bin/sh
# Détection automatique de la résolution pour tous les écrans
xrandr --output $(xrandr | grep " connected" | awk '{print $1}') --auto 2>/dev/null || true
EOF

sudo chmod +x /usr/share/sddm/scripts/Xsetup

print_success "Script Xsetup créé"

print_info "Redémarrage de SDDM recommandé"
print_warning "Exécutez: sudo systemctl restart sddm"
