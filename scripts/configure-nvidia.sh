#!/bin/bash

# Enable Nvidia Dynamic Power Management (Fine-grained) for better battery life on hybrid laptops
# This is equivalent to "options nvidia NVreg_DynamicPowerManagement=0x02" in modprobe.d
cat <<EOF > /etc/modprobe.d/nvidia-power-management.conf
options nvidia NVreg_DynamicPowerManagement=0x02
EOF
