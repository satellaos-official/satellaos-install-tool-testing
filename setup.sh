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
# 02 - Install Fish shell
# --------------------------------------------------
echo "02 - Installing Fish shell (required for installer)..."
chmod +x "$HOME/satellaos-install-tool/fish/fish.sh"
"$HOME/satellaos-install-tool/fish/fish.sh"

# --------------------------------------------------
# 03 - Enable and run APT sources configuration
# --------------------------------------------------
echo "03 - Configuring APT sources..."
chmod +x "$HOME/satellaos-install-tool/sources/sources.sh"
"$HOME/satellaos-install-tool/sources/sources.sh"

# --------------------------------------------------
# 04 - Run core desktop and base system setup
# --------------------------------------------------
echo "04 - Running core desktop and base system setup..."
chmod +x "$HOME/satellaos-install-tool/core/core.sh"
"$HOME/satellaos-install-tool/core/core.sh"

# --------------------------------------------------
# 05 - Apply Papirus Violet icon theme
# --------------------------------------------------
echo "05 - Applying Papirus Violet icon theme..."
chmod +x "$HOME/satellaos-install-tool/themes/papirus-violet.sh"
"$HOME/satellaos-install-tool/themes/papirus-violet.sh"

# --------------------------------------------------
# 06 - Apply Fluent GTK theme
# --------------------------------------------------
echo "06 - Applying Fluent GTK theme..."
chmod +x "$HOME/satellaos-install-tool/themes/Fluent-gtk-theme.sh"
"$HOME/satellaos-install-tool/themes/Fluent-gtk-theme.sh"

# --------------------------------------------------
# 07 - Configure sudo permissions for user
# --------------------------------------------------
echo "07 - Configuring sudo permissions..."
chmod +x "$HOME/satellaos-install-tool/sudo-permissions/adduser.sh"
"$HOME/satellaos-install-tool/sudo-permissions/adduser.sh"

# --------------------------------------------------
# 08 - Configure OS release information
# --------------------------------------------------
echo "08 - Setting OS release information..."
chmod +x "$HOME/satellaos-install-tool/os-release/os-release.sh"
"$HOME/satellaos-install-tool/os-release/os-release.sh"

# --------------------------------------------------
# 09 - Apply SatellaOS system logo
# --------------------------------------------------
echo "09 - Applying SatellaOS system logo..."
chmod +x "$HOME/satellaos-install-tool/logo/logo.sh"
"$HOME/satellaos-install-tool/logo/logo.sh"

# --------------------------------------------------
# 10 - Apply GRUB icon configuration
# --------------------------------------------------
echo "10 - Applying GRUB icon configuration..."
chmod +x "$HOME/satellaos-install-tool/grub-icon/grub-icon.sh"
"$HOME/satellaos-install-tool/grub-icon/grub-icon.sh"

# --------------------------------------------------
# 11 - Configure GRUB bootloader
# --------------------------------------------------
echo "11 - Configuring GRUB bootloader..."
chmod +x "$HOME/satellaos-install-tool/grub/grub.sh"
"$HOME/satellaos-install-tool/grub/grub.sh"

# --------------------------------------------------
# 12 - Installing GRUB Theme
# --------------------------------------------------
echo "12 - Installing GRUB Theme..."
sudo bash -c "cd $HOME/satellaos-install-tool/GRUB-Theme/Makima-1080p/ && ./install.sh"

# --------------------------------------------------
# 13 - Installing Drivers
# --------------------------------------------------
echo "13 - Applying to drivers..."
chmod +x "$HOME/satellaos-install-tool/drivers/drivers.sh"
"$HOME/satellaos-install-tool/drivers/drivers.sh"

# --------------------------------------------------
# 14 - Install wallpapers and backgrounds
# --------------------------------------------------
echo "14 - Installing wallpapers and backgrounds..."
chmod +x "$HOME/satellaos-install-tool/backgrounds/backgrounds.sh"
"$HOME/satellaos-install-tool/backgrounds/backgrounds.sh"

# --------------------------------------------------
# 15 - Apply application icons
# --------------------------------------------------
echo "15 - Applying application icons..."
chmod +x "$HOME/satellaos-install-tool/application-icon/application-icon.sh"
"$HOME/satellaos-install-tool/application-icon/application-icon.sh"

# --------------------------------------------------
# 16 - Apply interface customizations
# --------------------------------------------------
echo "16 - Applying interface customizations..."
chmod +x "$HOME/satellaos-install-tool/interfaces/interfaces.sh"
"$HOME/satellaos-install-tool/interfaces/interfaces.sh"

# --------------------------------------------------
# 17 - Install and configure Fastfetch
# --------------------------------------------------
echo "17 - Installing Fastfetch..."
chmod +x "$HOME/satellaos-install-tool/fastfetch/fastfetch.sh"
"$HOME/satellaos-install-tool/fastfetch/fastfetch.sh"

# --------------------------------------------------
# 18 - Fonts Installer
# --------------------------------------------------
echo "18 - Installing fonts..."
chmod +x "$HOME/satellaos-install-tool/fonts/fonts.sh"
"$HOME/satellaos-install-tool/fonts/fonts.sh"

# --------------------------------------------------
# 19 - Program install
# --------------------------------------------------
echo "19 - Installing programs..."
chmod +x "$HOME/satellaos-install-tool/satellaos-program-installer-tool.sh"
"$HOME/satellaos-install-tool/satellaos-program-installer-tool.sh"

# --------------------------------------------------
# 20 - Restore configuration to /etc/skel
# --------------------------------------------------
echo "20 - Restoring pre-saved configuration to /etc/skel..."
chmod +x "$HOME/satellaos-install-tool/skel/skel-restore.sh"
"$HOME/satellaos-install-tool/skel/skel-restore.sh"

# --------------------------------------------------
# 21 - Configure quiet console settings
# --------------------------------------------------
echo "21 - Configuring /etc/sysctl.d/99-quiet-console.conf..."
chmod +x "$HOME/satellaos-install-tool/config-quiet/config-quiet.sh"
"$HOME/satellaos-install-tool/config-quiet/config-quiet.sh"

# --------------------------------------------------
# 22 - Wrapper commands
# --------------------------------------------------
echo "22 - Wrapper commands adding..."
chmod +x "$HOME/satellaos-install-tool/command/command.sh"
"$HOME/satellaos-install-tool/command/command.sh"

# --------------------------------------------------
# 23 - uca.xml to creation
# --------------------------------------------------
echo "23 - creation uca.xml..."
chmod +x "$HOME/satellaos-install-tool/uca-create.sh"
"$HOME/satellaos-install-tool/uca-create.sh"

# --------------------------------------------------
# 24 - Apply final system configuration
# --------------------------------------------------
echo "24 - Applying final configuration..."
chmod +x "$HOME/satellaos-install-tool/config-restore.sh"
"$HOME/satellaos-install-tool/config-restore.sh"

echo "SatellaOS installation steps completed."