#!/bin/bash
set -ouex pipefail

# Install Epson Inkjet Printer Drivers (ESC/P-R)
# We use local RPMs to ensure build reproducibility and stability.

echo "Installing Epson printer drivers from local repository..."

# In BlueBuild, files/ are typically available in the build context
# We use dnf to handle potential local dependencies if any (though lsb is usually the only one)
dnf install -y /tmp/rpms/epson-inkjet-printer-escpr*.rpm

echo "Epson drivers installed successfully."
