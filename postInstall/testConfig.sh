#!/bin/bash

# Script de test de la configuration Hyprland
# Vérifie que tous les composants sont bien installés et configurés

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}==================================="
    echo -e "$1"
    echo -e "===================================${NC}"
}

print_test() {
    echo -ne "${BLUE}[TEST]${NC} $1... "
}

print_ok() {
    echo -e "${GREEN}✓${NC}"
}

print_fail() {
    echo -e "${RED}✗${NC}"
}

print_warn() {
    echo -e "${YELLOW}⚠${NC}"
}

test_command() {
    local cmd="$1"
    local desc="$2"
    
    print_test "$desc"
    if command -v "$cmd" &> /dev/null; then
        print_ok
        return 0
    else
        print_fail
        return 1
    fi
}

test_file() {
    local file="$1"
    local desc="$2"
    
    print_test "$desc"
    if [ -f "$file" ]; then
        print_ok
        return 0
    else
        print_fail
        return 1
    fi
}

test_service() {
    local service="$1"
    local desc="$2"
    
    print_test "$desc"
    if systemctl is-enabled "$service" &> /dev/null; then
        print_ok
        return 0
    else
        print_warn
        return 1
    fi
}

# Compteurs
total=0
passed=0
failed=0
warned=0

run_test() {
    ((total++))
    if "$@"; then
        ((passed++))
    else
        if [[ "$?" == "1" ]]; then
            ((failed++))
        else
            ((warned++))
        fi
    fi
}

print_header "Test de Configuration Hyprland"

echo ""
print_header "Composants Essentiels"
run_test test_command "hyprland" "Hyprland"
run_test test_command "hypridle" "Hypridle"
run_test test_command "hyprlock" "Hyprlock"
run_test test_command "hyprctl" "Hyprctl"
run_test test_command "sddm" "SDDM"

echo ""
print_header "Terminal et Shell"
run_test test_command "ghostty" "Ghostty"
run_test test_command "fish" "Fish"
run_test test_command "starship" "Starship"
run_test test_command "neovim" "Neovim"

echo ""
print_header "Utilitaires Wayland"
run_test test_command "swaync" "SwayNC (notifications)"
run_test test_command "qs" "QuickShell"
run_test test_command "swww" "SWWW (wallpaper)"
run_test test_command "grim" "Grim (screenshots)"
run_test test_command "slurp" "Slurp (region select)"

echo ""
print_header "Applications"
run_test test_command "thunar" "Thunar (file manager)"
run_test test_command "code" "VS Code"

echo ""
print_header "Audio et Bluetooth"
run_test test_command "pipewire" "PipeWire"
run_test test_command "wireplumber" "WirePlumber"
run_test test_command "pavucontrol" "PavuControl"
run_test test_command "bluetoothctl" "BluetoothCTL"

echo ""
print_header "Fichiers de Configuration"
run_test test_file "$HOME/.config/hypr/hyprland.conf" "hyprland.conf"
run_test test_file "$HOME/.config/hypr/myKeys.conf" "myKeys.conf"
run_test test_file "$HOME/.config/hypr/myColors.conf" "myColors.conf"
run_test test_file "$HOME/.config/hypr/autostart.conf" "autostart.conf"
run_test test_file "$HOME/.config/fish/config.fish" "fish config"

echo ""
print_header "Services Système"
run_test test_service "NetworkManager" "NetworkManager"
run_test test_service "bluetooth" "Bluetooth"
run_test test_service "sddm" "SDDM"

echo ""
print_header "Pilotes Graphiques"
print_test "Détection GPU"
if lspci | grep -E "VGA|3D" | grep -iq "intel"; then
    echo -e "${BLUE}Intel${NC}"
    run_test test_command "vainfo" "Intel VA-API"
fi

if lspci | grep -E "VGA|3D" | grep -iq "amd"; then
    echo -e "${BLUE}AMD${NC}"
    run_test test_command "vulkaninfo" "Vulkan (AMD)"
fi

if lspci | grep -E "VGA|3D" | grep -iq "nvidia"; then
    echo -e "${BLUE}NVIDIA${NC}"
    run_test test_command "nvidia-smi" "NVIDIA Tools"
fi

echo ""
print_header "Résumé"
echo -e "${BLUE}Total de tests:${NC} $total"
echo -e "${GREEN}Réussis:${NC} $passed"
echo -e "${RED}Échoués:${NC} $failed"
echo -e "${YELLOW}Avertissements:${NC} $warned"

echo ""
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration prête!${NC}"
    echo "Vous pouvez redémarrer et sélectionner Hyprland dans SDDM"
else
    echo -e "${YELLOW}⚠ Quelques composants manquent${NC}"
    echo "Relancez l'installation ou installez manuellement les paquets manquants"
fi
