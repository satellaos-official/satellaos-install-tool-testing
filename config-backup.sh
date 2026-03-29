#!/bin/bash
set -e

echo "Version 2.1"
BASE="$HOME/satellaos-install-tool/configuration"
OWNER="$USER:$USER"

echo "▶ Preparing configuration directory..."
mkdir -p "$BASE"

#################################
# BASHRC and PROFILE BACKUP
#################################

echo "▶ Backing up .bashrc and .profile files..."

mkdir -p "$BASE/configs"

[ -f "$HOME/.bashrc" ] && cp -a "$HOME/.bashrc" "$BASE/configs/"
[ -f "$HOME/.profile" ] && cp -a "$HOME/.profile" "$BASE/configs/"

#################################
# XFCE (USER)
#################################

echo "▶ Copying XFCE user configurations..."

mkdir -p "$BASE/xfce/user"

[ -d "$HOME/.config/xfce4" ] && \
cp -a "$HOME/.config/xfce4" "$BASE/xfce/user/"

#################################
# XFCONF (USER)
#################################

echo "▶ Copying XFCONF user database..."

mkdir -p "$BASE/xfce/xfconf"

[ -d "$HOME/.config/xfconf" ] && \
cp -a "$HOME/.config/xfconf" "$BASE/xfce/xfconf/"

#################################
# XFCE (SYSTEM DEFAULTS)
#################################

echo "▶ Copying XFCE system defaults..."

mkdir -p "$BASE/xfce/system"

sudo cp -a /etc/xdg/xfce4 \
           "$BASE/xfce/system/" 2>/dev/null || true

#################################
# FISH SHELL
#################################

echo "▶ Copying Fish shell configurations..."

mkdir -p "$BASE/fish/user"
mkdir -p "$BASE/fish/system"

[ -f "$HOME/.config/fish/config.fish" ] && \
cp -a "$HOME/.config/fish/config.fish" "$BASE/fish/user/"

sudo cp -a /etc/fish/config.fish \
           "$BASE/fish/system/" 2>/dev/null || true

#################################
# THUNAR (USER)
#################################

echo "▶ Copying Thunar configurations..."

mkdir -p "$BASE/thunar"

[ -d "$HOME/.config/Thunar" ] && \
cp -a "$HOME/.config/Thunar" "$BASE/thunar/"

#################################
# AUTOSTART
#################################

echo "▶ Copying Autostart files..."

mkdir -p "$BASE/autostart"

[ -d "$HOME/.config/autostart" ] && \
cp -a "$HOME/.config/autostart" "$BASE/autostart/"

#################################
# LIGHTDM
#################################
echo "▶ Copying LightDM configurations..."

mkdir -p "$BASE/lightdm/config"

sudo cp -a /etc/lightdm/lightdm.conf \
           "$BASE/lightdm/config/" 2>/dev/null || true
sudo cp -a /etc/lightdm/keys.conf \
           "$BASE/lightdm/config/" 2>/dev/null || true
sudo cp -a /etc/lightdm/users.conf \
           "$BASE/lightdm/config/" 2>/dev/null || true
#################################
# GTK GREETER
#################################
echo "▶ Copying GTK Greeter settings..."

mkdir -p "$BASE/lightdm/gtk-greeter"

sudo cp -a /etc/lightdm/lightdm-gtk-greeter.conf \
           "$BASE/lightdm/gtk-greeter/" 2>/dev/null || true        
sudo cp -a /etc/lightdm/lightdm-gtk-greeter.conf.d \
           "$BASE/lightdm/gtk-greeter/" 2>/dev/null || true

#################################
# OWNERSHIP & PERMISSIONS FIX
#################################

echo "▶ Transferring file ownership to user..."

sudo chown -R "$OWNER" "$BASE"

echo "▶ Adjusting permissions..."

find "$BASE" -type d -exec chmod 755 {} \;
find "$BASE" -type f -exec chmod 644 {} \;

echo "✅ XFCE + Thunar snapshot completed successfully."
echo "📁 Location: $BASE"