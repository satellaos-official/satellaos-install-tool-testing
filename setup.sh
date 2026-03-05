#!/bin/bash

echo "Version 13 (Trixie)"
# Ask the user if they want to start the installation
read -p "Do you want to start the SatellaOS installation? [Y/N]: " choice

# Convert the input to lowercase and check
case "${choice,,}" in
    y|yes)
        echo "Starting SatellaOS installation..."
        ;;
    n|no)
        echo "Installation canceled."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# SatellaOS main installer execution script
# This script prepares and runs all SatellaOS installer components in order

# --------------------------------------------------
# 00 - Install required base tools
# --------------------------------------------------
echo "00 - Installing required base tools (curl, wget)..."
sudo apt install --no-install-recommends -y curl wget

# --------------------------------------------------
# 01 - Install and ensure network connectivity
# --------------------------------------------------
echo "01 - Installing network components (required for installer)..."
chmod +x "$HOME/satellaos-install-tool/network/network.sh"
"$HOME/satellaos-install-tool/network/network.sh"

# --------------------------------------------------
# 02 - Enable and run APT sources configuration
# --------------------------------------------------
echo "02 - Configuring APT sources..."
chmod +x "$HOME/satellaos-install-tool/sources/sources.sh"
"$HOME/satellaos-install-tool/sources/sources.sh"

# --------------------------------------------------
# 03 - Run core desktop and base system setup
# --------------------------------------------------
echo "03 - Running core desktop and base system setup..."
chmod +x "$HOME/satellaos-install-tool/core/core.sh"
"$HOME/satellaos-install-tool/core/core.sh"

# --------------------------------------------------
# 04 - Apply Papirus Violet icon theme
# --------------------------------------------------
echo "04 - Applying Papirus Violet icon theme..."
chmod +x "$HOME/satellaos-install-tool/themes/papirus-violet.sh"
"$HOME/satellaos-install-tool/themes/papirus-violet.sh"

# --------------------------------------------------
# 05 - Apply Fluent GTK theme
# --------------------------------------------------
echo "05 - Applying Fluent GTK theme..."
chmod +x "$HOME/satellaos-install-tool/themes/Fluent-gtk-theme.sh"
"$HOME/satellaos-install-tool/themes/Fluent-gtk-theme.sh"

# --------------------------------------------------
# 06 - Configure sudo permissions for user
# --------------------------------------------------
echo "06 - Configuring sudo permissions..."
chmod +x "$HOME/satellaos-install-tool/sudo-permissions/adduser.sh"
"$HOME/satellaos-install-tool/sudo-permissions/adduser.sh"

# --------------------------------------------------
# 07 - Configure OS release information
# --------------------------------------------------
echo "07 - Setting OS release information..."
chmod +x "$HOME/satellaos-install-tool/os-release/os-release.sh"
"$HOME/satellaos-install-tool/os-release/os-release.sh"

# --------------------------------------------------
# 08 - Apply SatellaOS system logo
# --------------------------------------------------
echo "08 - Applying SatellaOS system logo..."
chmod +x "$HOME/satellaos-install-tool/logo/logo.sh"
"$HOME/satellaos-install-tool/logo/logo.sh"

# --------------------------------------------------
# 09 - Apply GRUB icon configuration
# --------------------------------------------------
echo "09 - Applying GRUB icon configuration..."
chmod +x "$HOME/satellaos-install-tool/grub-icon/grub-icon.sh"
"$HOME/satellaos-install-tool/grub-icon/grub-icon.sh"

# --------------------------------------------------
# 10 - Configure GRUB bootloader
# --------------------------------------------------
echo "10 - Configuring GRUB bootloader..."
chmod +x "$HOME/satellaos-install-tool/grub/grub.sh"
"$HOME/satellaos-install-tool/grub/grub.sh"

# --------------------------------------------------
# 11 - Installing GRUB Theme
# --------------------------------------------------
echo "11 - Installing GRUB Theme..."
sudo bash -c "cd $HOME/satellaos-install-tool/GRUB-Theme/Makima-1080p/ && ./install.sh"

# --------------------------------------------------
# 12 - Touchpad configuration (tap-to-click)
# --------------------------------------------------
echo "12 - Applying touchpad configuration..."
chmod +x "$HOME/satellaos-install-tool/drivers/touchpad-setup.sh"
"$HOME/satellaos-install-tool/drivers/touchpad-setup.sh"

# --------------------------------------------------
# 13 - Bluetooth setup
# --------------------------------------------------
echo "13 - Installing and configuring Bluetooth..."
chmod +x "$HOME/satellaos-install-tool/drivers/bluetooth-setup.sh"
"$HOME/satellaos-install-tool/drivers/bluetooth-setup.sh"

# --------------------------------------------------
# 14 - ADB Driver setup
# --------------------------------------------------
echo "14 - Installing ADB driver..."
chmod +x "$HOME/satellaos-install-tool/drivers/adb-setup.sh"
"$HOME/satellaos-install-tool/drivers/adb-setup.sh"

# --------------------------------------------------
# 15 - AMD graphics stack setup (optional)
# --------------------------------------------------
echo "15 - Running AMD graphics setup (optional)..."
chmod +x "$HOME/satellaos-install-tool/drivers/graphics-amd-setup.sh"
"$HOME/satellaos-install-tool/drivers/graphics-amd-setup.sh"

# --------------------------------------------------
# 16 - Intel graphics stack setup (optional)
# --------------------------------------------------
echo "16 - Running Intel graphics setup (optional)..."
chmod +x "$HOME/satellaos-install-tool/drivers/graphics-intel-setup.sh"
"$HOME/satellaos-install-tool/drivers/graphics-intel-setup.sh"

# --------------------------------------------------
# 17 - Install wallpapers and backgrounds
# --------------------------------------------------
echo "17 - Installing wallpapers and backgrounds..."
chmod +x "$HOME/satellaos-install-tool/backgrounds/backgrounds.sh"
"$HOME/satellaos-install-tool/backgrounds/backgrounds.sh"

# --------------------------------------------------
# 18 - Apply application icons
# --------------------------------------------------
echo "18 - Applying application icons..."
chmod +x "$HOME/satellaos-install-tool/application-icon/application-icon.sh"
"$HOME/satellaos-install-tool/application-icon/application-icon.sh"

# --------------------------------------------------
# 19 - Apply interface customizations
# --------------------------------------------------
echo "19 - Applying interface customizations..."
chmod +x "$HOME/satellaos-install-tool/interfaces/interfaces.sh"
"$HOME/satellaos-install-tool/interfaces/interfaces.sh"

# --------------------------------------------------
# 20 - Install and configure Fastfetch
# --------------------------------------------------
echo "20 - Installing Fastfetch..."
chmod +x "$HOME/satellaos-install-tool/fastfetch/fastfetch.sh"
"$HOME/satellaos-install-tool/fastfetch/fastfetch.sh"

# --------------------------------------------------
# 21 - Fonts Installer
# --------------------------------------------------
echo "21 - Installing fonts..."
chmod +x "$HOME/satellaos-install-tool/fonts/fonts.sh"
"$HOME/satellaos-install-tool/fonts/fonts.sh"

# --------------------------------------------------
# 22 - Program install
# --------------------------------------------------
echo "22 - Installing programs..."
chmod +x "$HOME/satellaos-install-tool/satellaos-program-installer-tool.sh"
"$HOME/satellaos-install-tool/satellaos-program-installer-tool.sh"

# --------------------------------------------------
# 23 - Restore configuration to /etc/skel
# --------------------------------------------------
echo "23 - Restoring pre-saved configuration to /etc/skel..."
chmod +x "$HOME/satellaos-install-tool/skel/skel-restore.sh"
"$HOME/satellaos-install-tool/skel/skel-restore.sh"

# --------------------------------------------------
# 24 - Configure quiet console settings
# --------------------------------------------------
echo "24 - Configuring /etc/sysctl.d/99-quiet-console.conf..."
chmod +x "$HOME/satellaos-install-tool/config-quiet/config-quiet.sh"
"$HOME/satellaos-install-tool/config-quiet/config-quiet.sh"

# --------------------------------------------------
# 25 - Wrapper commands
# --------------------------------------------------
echo "25 - Wrapper commands adding..."
chmod +x "$HOME/satellaos-install-tool/command/command.sh"
"$HOME/satellaos-install-tool/command/command.sh"

# --------------------------------------------------
# 26 - uca.xml to creation
# --------------------------------------------------
echo "26 - creation uca.xml..."
chmod +x "$HOME/satellaos-install-tool/uca-create.sh"
"$HOME/satellaos-install-tool/uca-create.sh"

# --------------------------------------------------
# 27 - Apply final system configuration
# --------------------------------------------------
echo "27 - Applying final configuration..."
chmod +x "$HOME/satellaos-install-tool/config-restore.sh"
"$HOME/satellaos-install-tool/config-restore.sh"

echo "SatellaOS installation steps completed."