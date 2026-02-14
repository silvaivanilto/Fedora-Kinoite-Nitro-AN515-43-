#!/bin/bash
set -ouex pipefail

# Upgrade all KDE packages to beta versions from the @kdesig/kde-beta COPR
dnf distro-sync -y --repo copr:copr.fedorainfracloud.org:group_kdesig:kde-beta
