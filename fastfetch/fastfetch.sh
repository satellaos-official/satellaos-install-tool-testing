#!/bin/bash

# Fastfetch Install Script

echo "▶ Starting Fastfetch installation..."

# Install Fastfetch
sudo apt update
sudo apt install --no-install-recommends -y fastfetch

echo "▶ Installation completed."

# Ask the user if they want to install a theme
read -p "Do you want to install a neofetch theme? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    # Create target folder if it doesn't exist
    mkdir -p "$HOME/.config/fastfetch"

    # Copy the theme file
    cp "$HOME/satellaos-installer/fastfetch/config.jsonc" "$HOME/.config/fastfetch/"

    echo "▶ Theme installed successfully."
else
    echo "▶ Theme installation skipped."
fi

echo "▶ Process completed."
