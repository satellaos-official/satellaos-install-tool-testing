#!/bin/bash

# --------------------------------------------------
# Core desktop packages and services setup
# Provides a usable XFCE-based system
# --------------------------------------------------
echo "Installing core system and XFCE desktop..."
sudo apt update

sudo apt install --no-install-recommends -y \
  xfce4 \
  xfce4-battery-plugin \
  xfce4-clipman \
  xfce4-clipman-plugin \
  xfce4-datetime-plugin \
  xfce4-docklike-plugin \
  xfce4-indicator-plugin \
  xfce4-panel \
  xfce4-panel-profiles \
  xfce4-power-manager \
  xfce4-power-manager-data \
  xfce4-power-manager-plugins \
  xfce4-pulseaudio-plugin \
  xfce4-session \
  xfce4-settings \
  xfce4-terminal \
  xfce4-whiskermenu-plugin \
  xfce4-notifyd \
  xfwm4 \
  xfdesktop4 \
  thunar \
  xorg \
  dbus-x11 \
  x11-xserver-utils \
  lightdm \
  slick-greeter \
  light-locker \
  ntfs-3g \
  pulseaudio \
  pavucontrol \
  alsa-utils \
  gvfs \
  gvfs-backends \
  gvfs-fuse

# --------------------------------------------------
# Fonts, themes, and visual customization
# Cosmetic and personalization packages
# --------------------------------------------------
echo "Installing fonts and visual customization..."
sudo apt install -y \
  fonts-bebas-neue \
  fonts-montserrat \
  adwaita-qt \
  gnome-themes-extra \
  bibata-cursor-theme


# --------------------------------------------------
# PolicyKit (GUI authorization support)
# --------------------------------------------------
echo "Installing policykit components..."
sudo apt install --no-install-recommends -y \
  mate-polkit \
  polkitd \
  pkexec

# --------------------------------------------------
# LightDM configuration
# --------------------------------------------------
echo "Configuring LightDM..."
sudo mkdir -p /etc/lightdm/lightdm.conf.d/
sudo bash -c 'cat > /etc/lightdm/lightdm.conf.d/10-slick.conf << "EOF"
[Seat:*]
greeter-session=slick-greeter
EOF'

# --------------------------------------------------
# Flatpak and Flathub (optional ecosystem)
# --------------------------------------------------
echo "Installing Flatpak and enabling Flathub..."
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installation completed. A system reboot is recommended."
