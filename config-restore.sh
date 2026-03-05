#!/bin/bash
set -e

echo "Version 2.4"
BASE="$HOME/satellaos-install-tool/configuration"

TARGET_USER="$HOME"
TARGET_ROOT="/root"

#################################
# BASHRC and PROFILE RESTORE (USER)
#################################

echo "▶ Restoring .bashrc and .profile for user..."

# Restore .bashrc for user
if [ -f "$BASE/configs/.bashrc" ]; then
    cp -a "$BASE/configs/.bashrc" "$TARGET_USER/"
    echo ".bashrc restored for user."
fi

# Restore .profile for user
if [ -f "$BASE/configs/.profile" ]; then
    cp -a "$BASE/configs/.profile" "$TARGET_USER/"
    echo ".profile restored for user."
fi

#################################
# BASHRC and PROFILE RESTORE (ROOT)
#################################

echo "▶ Restoring .bashrc and .profile for root..."

# Restore .bashrc for root
if [ -f "$BASE/configs/.bashrc" ]; then
    sudo cp -a "$BASE/configs/.bashrc" "$TARGET_ROOT/"
    echo ".bashrc restored for root."
fi

# Restore .profile for root
if [ -f "$BASE/configs/.profile" ]; then
    sudo cp -a "$BASE/configs/.profile" "$TARGET_ROOT/"
    echo ".profile restored for root."
fi

#################################
# XFCE (USER)
#################################
if [ -d "$BASE/xfce/user/xfce4" ]; then
    echo "▶ Restoring XFCE (user)..."
    rm -rf "$TARGET_USER/.config/xfce4"
    mkdir -p "$TARGET_USER/.config"
    cp -a "$BASE/xfce/user/xfce4" "$TARGET_USER/.config/"
fi

#################################
# XFCE (ROOT)
#################################
if [ -d "$BASE/xfce/user/xfce4" ]; then
    echo "▶ Restoring XFCE (root)..."
    sudo rm -rf "$TARGET_ROOT/.config/xfce4"
    sudo mkdir -p "$TARGET_ROOT/.config"
    sudo cp -a "$BASE/xfce/user/xfce4" "$TARGET_ROOT/.config/"
    sudo chown -R root:root "$TARGET_ROOT/.config/xfce4"
fi

#################################
# THUNAR (USER)
#################################
if [ -d "$BASE/thunar/Thunar" ]; then
    echo "▶ Restoring Thunar (user)..."
    rm -rf "$TARGET_USER/.config/Thunar"
    cp -a "$BASE/thunar/Thunar" "$TARGET_USER/.config/"
fi

#################################
# THUNAR (ROOT)
#################################
if [ -d "$BASE/thunar/Thunar" ]; then
    echo "▶ Restoring Thunar (root)..."
    sudo rm -rf "$TARGET_ROOT/.config/Thunar"
    sudo cp -a "$BASE/thunar/Thunar" "$TARGET_ROOT/.config/"
    sudo chown -R root:root "$TARGET_ROOT/.config/Thunar"
fi

#################################
# AUTOSTART (USER)
#################################
if [ -d "$BASE/autostart/autostart" ]; then
    echo "▶ Restoring Autostart (user)..."
    rm -rf "$TARGET_USER/.config/autostart"
    cp -a "$BASE/autostart/autostart" "$TARGET_USER/.config/"
fi

#################################
# AUTOSTART (ROOT)
#################################
if [ -d "$BASE/autostart/autostart" ]; then
    echo "▶ Restoring Autostart (root)..."
    sudo rm -rf "$TARGET_ROOT/.config/autostart"
    sudo cp -a "$BASE/autostart/autostart" "$TARGET_ROOT/.config/"
    sudo chown -R root:root "$TARGET_ROOT/.config/autostart"
fi

#################################
# XFCE (SYSTEM)
#################################
if [ -d "$BASE/xfce/system/xfce4" ]; then
    echo "▶ Restoring XFCE (system defaults)..."
    sudo rm -rf /etc/xdg/xfce4
    sudo cp -a "$BASE/xfce/system/xfce4" /etc/xdg/
fi

#################################
# XFCE (USER)
#################################
if [ -d "$BASE/xfce/user/xfce4" ]; then
    echo "▶ Restoring XFCE (user)..."
    
    # xfconfd'yi durdur ki üzerine yazmasın
    pkill xfconfd 2>/dev/null || true
    sleep 1
    
    rm -rf "$TARGET_USER/.config/xfce4"
    mkdir -p "$TARGET_USER/.config"
    cp -a "$BASE/xfce/user/xfce4" "$TARGET_USER/.config/"
    
    echo "XFCE (user) restored."
fi

#################################
# LIGHTDM (SYSTEM)
#################################
if [ -d "$BASE/lightdm/config/lightdm" ]; then
    echo "▶ Restoring LightDM configuration..."
    sudo rm -rf /etc/lightdm
    sudo cp -a "$BASE/lightdm/config/lightdm" /etc/
fi

#################################
# SLICK GREETER
#################################
if [ -d "$BASE/lightdm/slick-greeter" ]; then
    echo "▶ Restoring Slick Greeter settings..."
    sudo cp -a "$BASE/lightdm/slick-greeter/"* /etc/lightdm/ 2>/dev/null || true
fi

#################################
# LIGHTDM CACHE CLEANUP
#################################
sudo rm -rf /var/cache/lightdm/*
sudo rm -rf /var/lib/lightdm/.cache/*

#################################
# DONE
#################################
echo "✅ Restore completed successfully."
echo "🔁 Reboot is strongly recommended."

while true; do
    read -r -p "Do you want to restart the system? (Y/N): " answer
    case "$answer" in
        [Yy]* )
            echo "Restarting the system..."
            sudo reboot
            break
            ;;
        [Nn]* )
            echo "Restart cancelled."
            break
            ;;
        * )
            echo "Invalid option. Please enter Y or N."
            ;;
    esac
done
