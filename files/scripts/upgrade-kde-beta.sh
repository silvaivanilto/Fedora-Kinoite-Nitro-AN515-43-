#!/bin/bash
set -ouex pipefail

# Upgrade KDE packages to Plasma 6.5.91+ (Master/Beta) from @kdesig/kde-beta COPR
dnf upgrade -y --enablerepo=copr:copr.fedorainfracloud.org:group_kdesig:kde-beta
