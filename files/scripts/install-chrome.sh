#!/bin/bash
set -ouex pipefail

# Add Google Chrome RPM repository
cat > /etc/yum.repos.d/google-chrome.repo << 'EOF'
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

# Import Google's signing key
rpm --import https://dl.google.com/linux/linux_signing_key.pub

# Install Google Chrome Stable
dnf install -y google-chrome-stable

# Set Google Chrome as default browser (system-wide)
mkdir -p /etc/xdg
cat > /etc/xdg/mimeapps.list << 'EOF'
[Default Applications]
text/html=google-chrome.desktop
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
x-scheme-handler/about=google-chrome.desktop
x-scheme-handler/unknown=google-chrome.desktop
application/xhtml+xml=google-chrome.desktop
EOF
