#!/bin/bash
set -ouex pipefail

echo "Configuring TLP Power Management..."

# 1. Nitro 5 specific configuration
# Setting battery thresholds to protect battery longevity (Gaming laptop best practice)
mkdir -p /etc/tlp.d
cat <<EOF > /etc/tlp.d/99-nitro-5.conf
# TLP Customization for Acer Nitro 5
# Start charging at 75%, Stop at 80% to prevent battery degradation
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80

# Optimization for AMD Ryzen + Nvidia systems
PCIE_ASPM_ON_BAT=powersave
EOF

echo "TLP configured with Acer Nitro 5 battery health thresholds."
