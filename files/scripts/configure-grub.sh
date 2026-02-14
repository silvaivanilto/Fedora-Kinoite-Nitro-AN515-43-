#!/bin/bash
set -ouex pipefail

# Configure GRUB for Dual Boot (Windows detection) and Save Last Boot.
# On Fedora Atomic (Kinoite), /etc/default/grub might not exist or be empty.
# We create/append to it, but the user MUST run grub2-mkconfig manually later.

GRUB_FILE="/etc/default/grub"

# Create file if it doesn't exist (it usually does in the image build context, 
# but might be missing in some minimal base images)
if [ ! -f "$GRUB_FILE" ]; then
    echo "Creating $GRUB_FILE..."
    touch "$GRUB_FILE"
    echo "GRUB_TIMEOUT=5" >> "$GRUB_FILE"
    echo "GRUB_DISTRIBUTOR=\"$(sed 's, release .*$,,g' /etc/system-release)\"" >> "$GRUB_FILE"
    echo "GRUB_DEFAULT=saved" >> "$GRUB_FILE"
    echo "GRUB_DISABLE_SUBMENU=true" >> "$GRUB_FILE"
    echo "GRUB_TERMINAL_OUTPUT=\"console\"" >> "$GRUB_FILE"
    echo "GRUB_CMDLINE_LINUX=\"rhgb quiet\"" >> "$GRUB_FILE"
    echo "GRUB_DISABLE_RECOVERY=\"true\"" >> "$GRUB_FILE"
    echo "GRUB_ENABLE_BLSCFG=true" >> "$GRUB_FILE"
fi

# 0. Ensure boot is quiet (hide text) - append rhgb quiet if missing
if grep -q "GRUB_CMDLINE_LINUX" "$GRUB_FILE"; then
    if ! grep -q "rhgb" "$GRUB_FILE"; then
        sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 rhgb"/' "$GRUB_FILE"
    fi
    if ! grep -q "quiet" "$GRUB_FILE"; then
        sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 quiet"/' "$GRUB_FILE"
    fi
    if ! grep -q "rd.udev.log_priority=3" "$GRUB_FILE"; then
        sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 rd.udev.log_priority=3"/' "$GRUB_FILE"
    fi
else
    echo "GRUB_CMDLINE_LINUX=\"rhgb quiet rd.udev.log_priority=3\"" >> "$GRUB_FILE"
fi

# 1. Enable os-prober
if grep -q "GRUB_DISABLE_OS_PROBER" "$GRUB_FILE"; then
    sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE"
else
    echo "GRUB_DISABLE_OS_PROBER=false" >> "$GRUB_FILE"
fi

# 2. Enable saving the last selected OS
if grep -q "GRUB_SAVEDEFAULT" "$GRUB_FILE"; then
    sed -i 's/^GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' "$GRUB_FILE"
else
    echo "GRUB_SAVEDEFAULT=true" >> "$GRUB_FILE"
fi

# 3. Ensure default is set to 'saved'
if grep -q "GRUB_DEFAULT" "$GRUB_FILE"; then
    sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE"
else
    echo "GRUB_DEFAULT=saved" >> "$GRUB_FILE"
fi
