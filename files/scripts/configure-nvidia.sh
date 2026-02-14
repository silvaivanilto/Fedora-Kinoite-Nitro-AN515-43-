#!/bin/bash
set -ouex pipefail

# Enable Nvidia Dynamic Power Management
# http://download.nvidia.com/XFree86/Linux-x86_64/440.31/README/dynamicpowermanagement.html

echo "Configuring Nvidia Dynamic Power Management..."

cat <<EOF > /etc/modprobe.d/nvidia.conf
# Enable DynamicPwerManagement
# http://download.nvidia.com/XFree86/Linux-x86_64/440.31/README/dynamicpowermanagement.html
options nvidia NVreg_DynamicPowerManagement=0x02
EOF

echo "Created /etc/modprobe.d/nvidia.conf"
