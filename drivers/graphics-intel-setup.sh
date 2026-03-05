#!/bin/bash

# Intel graphics stack setup (firmware and media acceleration)
# Intel GPU drivers are included in the Linux kernel by default.
# This script installs OPTIONAL firmware and media packages.
# Recommended only if you experience video playback or performance issues.

set -e  # Exit on error

read -p "Do you want to install optional Intel graphics firmware and media support? (y/n): " yn
if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    echo "Intel graphics setup skipped."
    exit 0
fi

echo "Updating package lists..."
sudo apt update

echo "Installing Intel firmware and media drivers..."

sudo apt install -y \
    firmware-misc-nonfree \
    intel-media-va-driver \
    i965-va-driver \
    mesa-vulkan-drivers \
    mesa-va-drivers \
    mesa-vdpau-drivers

echo "Intel graphics stack installation completed."

echo "You can verify video acceleration with:"
echo "  vainfo"

echo "For OpenGL renderer information:"
echo "  glxinfo | grep 'OpenGL renderer'"

echo "If you were experiencing issues, a reboot or re-login may be required."
