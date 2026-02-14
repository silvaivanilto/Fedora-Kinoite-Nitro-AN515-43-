#!/bin/bash
set -ouex pipefail

# Upgrade KDE packages to beta versions from the @kdesig/kde-beta COPR (only if newer)
dnf upgrade -y --enablerepo=copr:copr.fedorainfracloud.org:group_kdesig:kde-beta
