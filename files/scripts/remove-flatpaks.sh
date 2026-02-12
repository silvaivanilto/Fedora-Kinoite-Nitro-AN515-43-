#!/bin/bash

# Remove all installed flatpaks, but do not remove repositories
flatpak uninstall --all -y

# Ensure removal of user data directories
rm -rf ~/.var
rm -rf /etc/skel/.var
