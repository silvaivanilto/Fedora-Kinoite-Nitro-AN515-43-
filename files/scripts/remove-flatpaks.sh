#!/bin/bash

# Remove all installed flatpaks, but do not remove repositories
flatpak uninstall --all -y

rm -rf ~/.var
rm -rf /etc/skel/.var
