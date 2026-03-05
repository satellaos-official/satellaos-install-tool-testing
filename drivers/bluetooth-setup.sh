#!/bin/bash

# Debian XFCE Bluetooth installation and service setup

read -p "Do you want to install and configure Bluetooth support? (y/n): " yn
if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    echo "Bluetooth setup skipped."
    exit 0
fi

echo "Updating package lists..."
sudo apt update

echo "Installing Bluetooth and BlueZ..."
sudo apt install -y bluetooth bluez

echo "Installing Blueman (XFCE Bluetooth GUI)..."
sudo apt install -y blueman

echo "Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "Bluetooth service status:"
systemctl status bluetooth
