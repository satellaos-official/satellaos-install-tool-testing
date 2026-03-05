#!/bin/bash

read -p "Do you want to installing ADB Driver? (y/n): " yn
if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    echo "ADB Driver skipped."
    exit 0
fi

echo "Installing user utilities and desktop tools..."
sudo apt install --no-install-recommends -y \
  mtp-tools \
  jmtpfs

echo "ADB Driver installing successfully."
echo "Please log out or reboot for the changes to take effect."
