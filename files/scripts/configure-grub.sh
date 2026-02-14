#!/bin/bash
set -ouex pipefail

# Modern GRUB configuration for Fedora Atomic (Kinoite)
# Focus: Ensure dual-boot visibility and remember last boot using grub2-editenv.

echo "Configuring GRUB for Atomic/Kinoite environment..."

# 1. Ensure the menu always appears (disable auto-hide)
# This is critical for dual-booting so the menu isn't skipped.
grub2-editenv - unset menu_auto_hide
grub2-editenv - set menu_hide_delay=

# 2. Set the GRUB timeout (in case it was hidden or too short)
# Using kargs as a secondary way to ensure visibility if the config allows.
# However, grub2-editenv is more direct for the menu behavior.
grub2-editenv - set boot_menu_timeout=5

# 3. Enable 'saved' entry logic
# This makes GRUB look at the 'saved_entry' variable in the environment.
grub2-editenv - set saved_entry=0
# Note: For this to work automatically (SAVEDEFAULT), the grub.cfg must support it.
# We still keep the /etc/default/grub flags as a template for when the user
# eventually runs grub2-mkconfig on the target system.

GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then
    echo "Updating $GRUB_FILE for potential future mkconfig runs..."
    
    # Enable os-prober for Dual Boot detection
    sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE" || echo "GRUB_DISABLE_OS_PROBER=false" >> "$GRUB_FILE"
    
    # Enable saving the last selected OS
    sed -i 's/^GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' "$GRUB_FILE" || echo "GRUB_SAVEDEFAULT=true" >> "$GRUB_FILE"
    
    # Ensure default is set to 'saved'
    sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE" || echo "GRUB_DEFAULT=saved" >> "$GRUB_FILE"
else
    # Minimal template if missing
    cat <<EOF > "$GRUB_FILE"
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="\$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
GRUB_DISABLE_OS_PROBER=false
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rhgb quiet rd.udev.log_priority=3"
GRUB_ENABLE_BLSCFG=true
EOF
fi

echo "GRUB configuration applied via grub2-editenv and template update."
