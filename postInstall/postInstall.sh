#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Couleurs pour l'affichage
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

print_info "==================================="
print_info "Post-Installation Hyprland Dotfiles"
print_info "Configuration Multi-Environnement"
print_info "==================================="

# Vérifier si on est dans le bon répertoire
if [ ! -d "$REPO_DIR/.config" ]; then
    print_error "Erreur: .config non trouvé dans $REPO_DIR"
    print_error "Assurez-vous d'exécuter ce script depuis le dossier postInstall du repo"
    exit 1
fi

# 1. Mise à jour du système
print_info "Étape 1/7: Mise à jour du système..."
sudo pacman -Syu --noconfirm
print_success "Système mis à jour"

# 2. Installation des paquets avec détection matérielle
print_info "Étape 2/7: Installation des paquets..."
bash "$SCRIPT_DIR/pkgInstall.sh"
print_success "Paquets installés"

# 2. Configuration de GRUB (optionnel)
print_info "Étape 2/7: Configuration de GRUB..."
if [ -f "$SCRIPT_DIR/grubInstall.sh" ]; then
    bash "$SCRIPT_DIR/grubInstall.sh"
else
    print_warning "grubInstall.sh non trouvé, passage à l'étape suivante"
fi

# 3. Configuration de SDDM
print_info "Étape 3/7: Configuration de SDDM pour résolution automatique..."
if [ -f "$SCRIPT_DIR/sddmConfig.sh" ]; then
    bash "$SCRIPT_DIR/sddmConfig.sh"
    print_success "SDDM configuré"
else
    print_warning "sddmConfig.sh non trouvé, passage à l'étape suivante"
fi

# 4. Créer les dossiers utilisateur
print_info "Étape 4/7: Création des dossiers utilisateur..."
for dir in Documents Images Musique Téléchargements Vidéos; do
    mkdir -p "$HOME/$dir"
done
print_success "Dossiers créés"

# 5. Déploiement des configurations
print_info "Étape 5/7: Déploiement des configurations..."
if [ -f "$REPO_DIR/.config/scripts/deploy.sh" ]; then
    bash "$REPO_DIR/.config/scripts/deploy.sh"
    print_success "Configurations déployées"
else
    print_error "Script de déploiement non trouvé"
    exit 1
fi

# 6. Configuration du shell par défaut
print_info "Étape 6/7: Configuration de Fish comme shell par défaut..."
if command -v fish >/dev/null 2>&1; then
    if [ "$SHELL" != "$(which fish)" ]; then
        print_info "Changement du shell par défaut vers Fish..."
        chsh -s "$(which fish)"
        print_success "Shell changé vers Fish (redémarrez la session pour appliquer)"
    else
        print_success "Fish est déjà le shell par défaut"
    fi
else
    print_warning "Fish n'est pas installé, shell non modifié"
fi

# 7. Configuration supplémentaire
print_info "Étape 7/7: Configurations finales..."

# Activer zram si le générateur est présent
if [ -f /usr/lib/systemd/system-generators/zram-generator ]; then
    print_info "Configuration de zram..."
    sudo mkdir -p /etc/systemd/zram-generator.conf.d
    cat << EOF | sudo tee /etc/systemd/zram-generator.conf.d/zram.conf > /dev/null
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
EOF
    print_success "zram configuré"
fi

# Créer le lien symbolique pour github.pub si présent
if [ -f "$REPO_DIR/github.pub" ]; then
    mkdir -p "$HOME/.ssh"
    if [ ! -L "$HOME/.ssh/id_rsa.pub" ]; then
        ln -sf "$REPO_DIR/github.pub" "$HOME/.ssh/id_rsa.pub"
        print_success "Clé SSH liée"
    fi
fi

# Configuration de git
if command -v git >/dev/null 2>&1; then
    print_info "Configurez votre identité git:"
    read -p "Nom d'utilisateur git (ou Entrée pour ignorer): " git_name
    read -p "Email git (ou Entrée pour ignorer): " git_email
    
    if [ -n "$git_name" ]; then
        git config --global user.name "$git_name"
    fi
    if [ -n "$git_email" ]; then
        git config --global user.email "$git_email"
    fi
fi

print_success "=================================="
print_success "Installation terminée avec succès!"
print_success "=================================="
print_info ""
print_info "Prochaines étapes:"
print_info "1. Redémarrez votre session pour appliquer tous les changements"
print_info "2. Connectez-vous avec SDDM"
print_info "3. Sélectionnez Hyprland comme environnement"
print_info ""
print_warning "Si Hyprland ne démarre pas, essayez:"
print_warning "  - Vérifier les logs: journalctl -b"
print_warning "  - Réinstaller les pilotes graphiques"
print_info ""
