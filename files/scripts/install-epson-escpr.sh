#!/bin/bash
set -ouex pipefail

# Install Epson Inkjet Printer Drivers (ESC/P-R) from Fedora 41
# Packages were orphaned and are not available in Fedora 43
rpm-ostree install \
  https://kojipkgs.fedoraproject.org//packages/epson-inkjet-printer-escpr/1.7.21/7.1lsb3.2.fc41/x86_64/epson-inkjet-printer-escpr-1.7.21-7.1lsb3.2.fc41.x86_64.rpm \
  https://kojipkgs.fedoraproject.org//packages/epson-inkjet-printer-escpr2/1.1.49/6.1lsb3.2.fc41/x86_64/epson-inkjet-printer-escpr2-1.1.49-6.1lsb3.2.fc41.x86_64.rpm
