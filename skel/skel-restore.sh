#!/bin/bash

# Source and destination directories
SOURCE_DIR="$HOME/satellaos-installer/skel/"
DEST_DIR="/etc/skel/"

# Install rsync
sudo apt install -y rsync

# Ensure the destination directory exists (with root privileges)
sudo mkdir -p "$DEST_DIR"

# Copy files while excluding .sh scripts (with root privileges)
sudo rsync -a --delete --exclude="*.sh" "$SOURCE_DIR" "$DEST_DIR"

# Set ownership to root (with root privileges)
sudo chown -R root:root "$DEST_DIR"

echo "Reverse copy completed successfully."
echo ".sh files were ignored."
echo "All files are now owned by root."
