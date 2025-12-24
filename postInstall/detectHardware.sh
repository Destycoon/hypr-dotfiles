#!/bin/bash

# Script de détection matérielle pour installer uniquement les pilotes nécessaires

set -e

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

# Détection du GPU
detect_gpu() {
    print_info "Détection du GPU..."
    
    GPU_PACKAGES=()
    
    # Détection Intel
    if lspci | grep -E "VGA|3D" | grep -iq "intel"; then
        print_success "GPU Intel détecté"
        GPU_PACKAGES+=(
            "intel-media-driver"
            "libva-intel-driver"
            "vulkan-intel"
        )
        # Intel ucode déjà dans l'installation de base normalement
        if ! pacman -Q intel-ucode &>/dev/null; then
            GPU_PACKAGES+=("intel-ucode")
        fi
    fi
    
    # Détection AMD
    if lspci | grep -E "VGA|3D" | grep -iq "amd\|radeon"; then
        print_success "GPU AMD détecté"
        GPU_PACKAGES+=(
            "vulkan-radeon"
            "xf86-video-amdgpu"
            "xf86-video-ati"
        )
        if ! pacman -Q amd-ucode &>/dev/null; then
            GPU_PACKAGES+=("amd-ucode")
        fi
    fi
    
    # Détection NVIDIA
    if lspci | grep -E "VGA|3D" | grep -iq "nvidia"; then
        print_success "GPU NVIDIA détecté"
        GPU_PACKAGES+=(
            "nvidia"
            "nvidia-utils"
            "nvidia-settings"
        )
    fi
    
    # Détection Nouveau (fallback NVIDIA)
    if lspci | grep -E "VGA|3D" | grep -iq "nvidia" && [ ${#GPU_PACKAGES[@]} -eq 0 ]; then
        print_warning "NVIDIA détecté, utilisation du pilote Nouveau (open source)"
        GPU_PACKAGES+=(
            "vulkan-nouveau"
            "xf86-video-nouveau"
        )
    fi
    
    # Si aucun GPU détecté, packages génériques
    if [ ${#GPU_PACKAGES[@]} -eq 0 ]; then
        print_warning "Aucun GPU spécifique détecté, installation des pilotes génériques"
        GPU_PACKAGES+=(
            "mesa"
            "vulkan-mesa-layers"
        )
    fi
    
    # Installation des pilotes
    if [ ${#GPU_PACKAGES[@]} -gt 0 ]; then
        print_info "Installation des pilotes GPU: ${GPU_PACKAGES[*]}"
        sudo pacman -S --noconfirm --needed "${GPU_PACKAGES[@]}"
        print_success "Pilotes GPU installés"
    fi
}

# Détection du firmware
detect_firmware() {
    print_info "Vérification du firmware nécessaire..."
    
    FIRMWARE_PACKAGES=()
    
    # Firmware audio (généralement nécessaire)
    if ! pacman -Q sof-firmware &>/dev/null; then
        FIRMWARE_PACKAGES+=("sof-firmware")
    fi
    
    # Firmware Linux générique
    if ! pacman -Q linux-firmware &>/dev/null; then
        FIRMWARE_PACKAGES+=("linux-firmware")
        FIRMWARE_PACKAGES+=("mkinitcpio-firmware")
    fi
    
    if [ ${#FIRMWARE_PACKAGES[@]} -gt 0 ]; then
        print_info "Installation du firmware: ${FIRMWARE_PACKAGES[*]}"
        sudo pacman -S --noconfirm --needed "${FIRMWARE_PACKAGES[@]}"
        print_success "Firmware installé"
    else
        print_success "Firmware déjà présent"
    fi
}

# Détection réseau sans fil
detect_wireless() {
    print_info "Détection du matériel réseau sans fil..."
    
    WIRELESS_PACKAGES=()
    
    # Vérifier si une carte WiFi est présente
    if lspci | grep -iq "network\|wireless\|wi-fi\|802.11"; then
        print_success "Carte réseau sans fil détectée"
        
        # NetworkManager et ses outils (si pas déjà installé)
        if ! pacman -Q networkmanager &>/dev/null; then
            WIRELESS_PACKAGES+=("networkmanager" "network-manager-applet")
        fi
        
        # iwd pour meilleure compatibilité
        if ! pacman -Q iwd &>/dev/null; then
            WIRELESS_PACKAGES+=("iwd")
        fi
        
        # wireless_tools si pas déjà présent
        if ! pacman -Q wireless_tools &>/dev/null; then
            WIRELESS_PACKAGES+=("wireless_tools")
        fi
    fi
    
    if [ ${#WIRELESS_PACKAGES[@]} -gt 0 ]; then
        print_info "Installation des outils WiFi: ${WIRELESS_PACKAGES[*]}"
        sudo pacman -S --noconfirm --needed "${WIRELESS_PACKAGES[@]}"
        print_success "Outils WiFi installés"
    fi
}

# Exécution
print_info "==================================="
print_info "Détection matérielle du système"
print_info "==================================="

detect_firmware
detect_gpu
detect_wireless

print_success "==================================="
print_success "Détection matérielle terminée"
print_success "==================================="
