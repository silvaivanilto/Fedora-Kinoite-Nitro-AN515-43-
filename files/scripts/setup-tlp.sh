#!/bin/bash
set -ouex pipefail

# Install TLP RPM release (Repo)
rpm-ostree install https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm
