#!/bin/bash
# AMD graphics stack setup (AMDGPU, Mesa, firmware)
# Compatible with AMD APUs and GPUs (Vega, RDNA, RDNA2, RDNA3)

set -e  # Stop script on error

read -p "Do you want to install AMD graphics drivers? (y/n): " yn
if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    echo "AMD graphics driver installation skipped."
    exit 0
fi

echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "Installing AMD firmware and Mesa drivers..."
sudo apt install -y firmware-amd-graphics \
                    mesa-vulkan-drivers \
                    mesa-va-drivers \
                    mesa-vdpau-drivers

echo "Installation completed successfully."

echo "To verify the driver, run:"
echo "  lspci -k | grep -EA3 'VGA|3D'"

echo "To check hardware acceleration:"
echo "  glxinfo | grep 'OpenGL renderer'"

echo "You may reboot the system using:"
echo "  sudo reboot"
