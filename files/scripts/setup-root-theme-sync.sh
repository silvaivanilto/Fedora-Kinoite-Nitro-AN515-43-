#!/bin/bash
set -ouex pipefail

echo "Configuring Root Theme Synchronization Service..."

# 1. Create a systemd service to sync root KDE config with the primary user (UID 1000)
# This ensures that apps run as root share the same visual theme and settings.
cat <<EOF > /etc/systemd/system/root-theme-sync.service
[Unit]
Description=Sync root KDE theme with UID 1000
After=local-fs.target
# Only run if the primary user's home directory exists
ConditionPathExists=/home/$(getent passwd 1000 | cut -d: -f1)

[Service]
Type=oneshot
ExecStart=/bin/bash -c ' \
    U_HOME=\$(getent passwd 1000 | cut -d: -f6); \
    if [ -n "\$U_HOME" ]; then \
        mkdir -p /root/.config; \
        ln -sf "\$U_HOME/.config/kdeglobals" /root/.config/kdeglobals; \
        ln -sf "\$U_HOME/.config/katerc" /root/.config/katerc; \
        ln -sf "\$U_HOME/.config/kcminputrc" /root/.config/kcminputrc; \
    fi'

[Install]
WantedBy=multi-user.target
EOF

# 2. Enable the service
systemctl enable root-theme-sync.service

echo "Root theme synchronization configured successfully."
