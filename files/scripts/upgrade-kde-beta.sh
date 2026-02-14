#!/bin/bash
set -ouex pipefail

echo "Upgrading KDE Plasma to Beta/Master versions..."

# Upgrade all KDE-related packages to Plasma 6.5.91+ (Master/Beta) 
# This targets the @kdesig/kde-beta COPR repo defined in recipe.yml
dnf upgrade -y --enablerepo=copr:copr.fedorainfracloud.org:group_kdesig:kde-beta

echo "KDE Plasma upgrade completed successfully."
