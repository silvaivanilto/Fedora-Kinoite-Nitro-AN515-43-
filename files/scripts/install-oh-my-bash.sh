#!/bin/bash
set -ouex pipefail

# Configuration
# Theme choice: 'powerline' requires Powerline/Nerd Fonts (already included in recipe)
OMB_THEME="powerline"
OMB_PLUGINS="git bash-completion extract history-substring-search"

echo "Installing Oh My Bash to /etc/skel..."

# 1. Clean and Clone OMB
# We use a shallow clone to keep the image size small
if [ -d "/etc/skel/.oh-my-bash" ]; then
    rm -rf /etc/skel/.oh-my-bash
fi
git clone --depth=1 https://github.com/ohmybash/oh-my-bash.git /etc/skel/.oh-my-bash

# 2. Setup .bashrc from template
cp /etc/skel/.oh-my-bash/templates/bashrc.osh-template /etc/skel/.bashrc

# 3. Apply Customizations (Theme & Plugins)
# Replace the default theme in the template
sed -i "s/OSH_THEME=\"font\"/OSH_THEME=\"$OMB_THEME\"/" /etc/skel/.bashrc

# 4. Append Fedora Defaults and Aesthetics
# We preserve Fedora's global definitions and add user terminal preferences
cat <<EOF >> /etc/skel/.bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Visual Adjustments
# Set cursor to underline (User request)
printf '\e[4 q'
EOF

echo "Oh My Bash installation configured successfully."
