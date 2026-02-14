#!/bin/bash
set -ouex pipefail

# Install Epson Inkjet Printer Drivers (ESC/P-R)
# We use local RPMs to ensure build reproducibility and stability.

echo "Installing Epson printer drivers from local repository..."

# In BlueBuild, files/ are typically available in the build context
# We use dnf to handle potential local dependencies if any (though lsb is usually the only one)
# We use rpm directly with --nodigest --nosignature because older Epson RPMs 
# often lack the digests required by newer RPM/DNF versions in Fedora 43+.
rpm -ivh --nodigest --nosignature /tmp/files/rpms/epson-inkjet-printer-escpr*.rpm

echo "Epson drivers installed successfully."
