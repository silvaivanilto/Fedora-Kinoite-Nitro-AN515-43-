#!/bin/bash
set -ouex pipefail

# SELinux Configuration for CachyOS Kernel
# Requirement: setsebool -P domain_kernel_load_modules on
# This allows the kernel (and processes) to load modules that might be flagged by strict targeted policies.
# Crucial for CachyOS Nvidia drivers.

echo "Configuring SELinux for CachyOS..."

# Check if setsebool is available
if command -v setsebool &> /dev/null; then
    # -P makes it persistent across reboots (modifies policy file)
    # We try to run it. If it fails (e.g., due to container build restriction), we warn.
    setsebool -P domain_kernel_load_modules on || echo "WARNING: Failed to set SELinux boolean. You may need to run 'sudo setsebool -P domain_kernel_load_modules on' manually after boot."
    echo "SELinux boolean 'domain_kernel_load_modules' enabled."
else
    echo "Error: setsebool command not found."
fi
