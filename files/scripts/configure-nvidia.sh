#!/bin/bash
set -ouex pipefail

# Enable Nvidia Dynamic Power Management (Fine-grained) for better battery life on hybrid laptops
cat <<EOF > /etc/modprobe.d/nvidia-power-management.conf
options nvidia NVreg_DynamicPowerManagement=0x02
EOF
