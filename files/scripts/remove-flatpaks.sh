#!/bin/bash

# Remove all installed flatpaks, but do not remove repositories
flatpak uninstall --all -y

# Ensure removal of user data directories (but do NOT remove global repository)
rm -rf ~/.var           # Remove from current user (root in build)
rm -rf /etc/skel/.var   # Remove from new user template

# Configure Remotes as requested
# Add Flathub
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --system --enable flathub
