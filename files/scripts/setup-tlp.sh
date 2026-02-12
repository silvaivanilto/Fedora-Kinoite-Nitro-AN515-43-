#!/bin/bash
set -ouex pipefail

# Install TLP RPM release (Repo)
# Note: We use rpm-ostree install directly to install the RPM from the repository
rpm-ostree install https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm

# Install TLP packages
rpm-ostree install tlp tlp-pd tlp-rdw

# Enable TLP services
systemctl enable tlp.service
systemctl enable tlp-pd.service

# Mask conflicting services (rfkill, tuned)
systemctl mask systemd-rfkill.service systemd-rfkill.socket tuned.service tuned-ppd.service
