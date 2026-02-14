#!/bin/bash
set -ouex pipefail

# Install Upstream TLP Repo (Linrunner) for latest version (1.9.1+)
rpm-ostree install https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm
