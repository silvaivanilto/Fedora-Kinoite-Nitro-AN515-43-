#!/bin/bash
set -ouex pipefail

# Ensure CachyOS Kernel is set as default in GRUB
# Logic adapted from user request: grubby --set-default=/boot/$(ls /boot | grep vmlinuz.*cachy | sort -V | tail -1)

# Note: In an image build process, /boot might not be populated exactly as in a running system.
# However, we can try to find the kernel or just set the instruction.
# Since we removed the stock kernel, CachyOS should be the only one.
# But running grubby is a good safety measure if feasible.

echo "Setting CachyOS kernel as default..."

# Find the installed CachyOS kernel version
CACHY_KERNEL=$(rpm -qa | grep kernel-cachyos | sort -V | tail -n 1)

if [ -n "$CACHY_KERNEL" ]; then
    echo "Found CachyOS kernel package: $CACHY_KERNEL"
    # Attempt to set default if /boot is accessible and populated (which depends on the build env)
    # If not, this might need to run on first boot.
    # For now, we'll try to execute the user's specific command logic if /boot/vmlinuz*cachy exists.
    
    if ls /boot/vmlinuz*cachy >/dev/null 2>&1; then
        grubby --set-default="/boot/$(ls /boot | grep vmlinuz.*cachy | sort -V | tail -1)"
        echo "Default kernel set using grubby."
    else
        echo "Warning: /boot/vmlinuz*cachy not found in build env. Skipping grubby."
    fi
else
    echo "Error: kernel-cachyos not found in rpm database!"
fi

# User requested permission fix (though strictly not needed if we are root in build, but honoring request)
# sudo chown root:root /etc/kernel/postinst.d/99-default ; sudo chmod u+rx /etc/kernel/postinst.d/99-default
# We don't have a 99-default file here, but we can assume this script acts as one or we create it.
# Let's create the dummy file to satisfy the user's "postinst" logic if they want to verify it exists.

mkdir -p /etc/kernel/postinst.d
cat << 'EOF' > /etc/kernel/postinst.d/99-default
#!/bin/sh

set -e

grubby --set-default=/boot/$(ls /boot | grep vmlinuz.*cachy | sort -V | tail -1)
EOF

chown root:root /etc/kernel/postinst.d/99-default
chmod u+rx /etc/kernel/postinst.d/99-default

echo "Created /etc/kernel/postinst.d/99-default hook."
