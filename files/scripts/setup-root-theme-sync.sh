#!/bin/bash
set -ouex pipefail

# Create a systemd service to sync root KDE config with the primary user (UID 1000)
# This allows root apps (like dnfdragora or others, if used) to look consistent with the user theme.

cat <<EOF > /etc/systemd/system/root-theme-sync.service
[Unit]
Description=Sync root KDE theme with UID 1000
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'U_HOME=\$(getent passwd 1000 | cut -d: -f6); if [ -n "\$U_HOME" ]; then mkdir -p /root/.config; ln -sf "\$U_HOME/.config/kdeglobals" /root/.config/kdeglobals; ln -sf "\$U_HOME/.config/katerc" /root/.config/katerc; fi'

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable root-theme-sync.service
