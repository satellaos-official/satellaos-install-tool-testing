#!/bin/bash

# Enable tap-to-click for touchpad using libinput

read -p "Do you want to enable tap-to-click for the touchpad? (y/n): " yn
if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    echo "Touchpad tap-to-click configuration skipped."
    exit 0
fi

echo "Applying touchpad tap-to-click configuration..."

sudo mkdir -p /etc/X11/xorg.conf.d

sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null <<EOF
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "Tapping" "on"
EndSection
EOF

echo "Tap-to-click has been enabled successfully."
echo "Please log out or reboot for the changes to take effect."
