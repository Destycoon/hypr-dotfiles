#!/bin/bash

CARD="alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
PROFILE="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"

# Activer le profil Speaker
pactl set-card-profile "$CARD" "$PROFILE"

# Définir le Speaker comme sortie par défaut
pactl set-default-sink "$SINK"
