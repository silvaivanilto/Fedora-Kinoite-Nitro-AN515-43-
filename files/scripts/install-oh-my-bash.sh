#!/bin/bash
set -ouex pipefail

# Install oh-my-bash to /etc/skel so new users receive it automatically
# We clone deeply to /etc/skel/.oh-my-bash
if [ -d "/etc/skel/.oh-my-bash" ]; then
    rm -rf /etc/skel/.oh-my-bash
fi
git clone --depth=1 https://github.com/ohmybash/oh-my-bash.git /etc/skel/.oh-my-bash

# Backup existing .bashrc in skel
if [ -f "/etc/skel/.bashrc" ]; then
    mv /etc/skel/.bashrc /etc/skel/.bashrc.fedora
fi

# Copy the template over as the new .bashrc
cp /etc/skel/.oh-my-bash/templates/bashrc.osh-template /etc/skel/.bashrc

# Modify .bashrc to source /etc/bashrc (Fedora default behavior)
# This ensures system-wide settings are loaded
echo "" >> /etc/skel/.bashrc
echo "# Source global definitions" >> /etc/skel/.bashrc
echo "if [ -f /etc/bashrc ]; then" >> /etc/skel/.bashrc
echo "	. /etc/bashrc" >> /etc/skel/.bashrc
echo "fi" >> /etc/skel/.bashrc

# Set cursor to underline (User request)
# \e[4 q is the escape sequence for underline cursor
echo "" >> /etc/skel/.bashrc
echo "# Set cursor to underline" >> /etc/skel/.bashrc
echo "printf '\e[4 q'" >> /etc/skel/.bashrc
