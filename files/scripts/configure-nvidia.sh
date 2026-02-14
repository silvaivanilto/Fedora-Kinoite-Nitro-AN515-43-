#!/bin/bash
set -ouex pipefail

echo "Optimizing Nvidia for Acer Nitro 5 (Ryzen/Turing)..."

# 1. Configure Modprobe for Fine-Grained Power Management
# Ref: http://download.nvidia.com/XFree86/Linux-x86_64/440.31/README/dynamicpowermanagement.html
cat <<EOF > /etc/modprobe.d/nvidia.conf
# Enable Dynamic Power Management (Mode 0x02 = Fine-grained)
options nvidia "NVreg_DynamicPowerManagement=0x02"

# Optional: If you notice "Deep Sleep" instability on Ryzen systems, 
# uncomment the line below to disable GSP firmware:
# options nvidia "NVreg_EnableGpuFirmware=0"
EOF

# 2. Ensure correct permissions
chmod 644 /etc/modprobe.d/nvidia.conf

echo "Nvidia power settings applied."
