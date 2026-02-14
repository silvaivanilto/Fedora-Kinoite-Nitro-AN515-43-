#!/bin/bash
set -ouex pipefail

# Modern GRUB configuration for Fedora Atomic (Kinoite)
# Focus: Ensure dual-boot visibility and remember last boot.
# SAFE: This script does NOT touch kernel parameters (kargs).

echo "Configuring GRUB for Atomic/Kinoite environment..."

# Note: We avoid grub2-editenv here because /boot is not accessible 
# inside the build container. We focus on /etc/default/grub instead.

# 4. Update /etc/default/grub WITHOUT touching kernel command line (GRUB_CMDLINE_LINUX)
# These flags are necessary for os-prober and saving the default SO.
GRUB_FILE="/etc/default/grub"

if [ ! -f "$GRUB_FILE" ]; then
    echo "Creating minimal $GRUB_FILE..."
    touch "$GRUB_FILE"
fi

echo "Setting dual-boot flags in $GRUB_FILE..."
# Enable os-prober
sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE" || echo "GRUB_DISABLE_OS_PROBER=false" >> "$GRUB_FILE"
# Enable saving the last selected OS
sed -i 's/^GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' "$GRUB_FILE" || echo "GRUB_SAVEDEFAULT=true" >> "$GRUB_FILE"
# Ensure default is set to 'saved'
sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE" || echo "GRUB_DEFAULT=saved" >> "$GRUB_FILE"

echo "GRUB configuration applied. Default kernel parameters were NOT modified."
