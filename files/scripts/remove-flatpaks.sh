#!/bin/bash

# Remove all installed flatpaks, but do not remove repositories
flatpak uninstall --all -y

# Ensure removal of user data directories (but do NOT remove global repository)
rm -rf ~/.var           # Remove from current user (root in build)
rm -rf /etc/skel/.var   # Remove from new user template

# Note: Flathub remote configuration is now handled by the 'default-flatpaks' module in recipe.yml
