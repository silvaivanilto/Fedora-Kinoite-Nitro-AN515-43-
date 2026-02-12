#!/bin/bash
set -ouex pipefail

# Install RPM Fusion Repositories
rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Swap ffmpeg-free for full ffmpeg
rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free ffmpeg-free --install ffmpeg

# Update multimedia group (excluding PackageKit plugin to avoid conflicts)
# Note: In ostree, we install packages directly rather than using groupupdate
rpm-ostree install @multimedia --exclude=PackageKit-gstreamer-plugin

# Swap Mesa drivers for Freeworld versions (VAAPI/VDPAU)
# This is crucial for AMD iGPU hardware acceleration
rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld
rpm-ostree override remove mesa-vdpau-drivers --install mesa-vdpau-drivers-freeworld

# Install NVidia VAAPI driver
rpm-ostree install libva-nvidia-driver
