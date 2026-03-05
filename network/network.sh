# --------------------------------------------------
# Network base configuration
# Installs and enables NetworkManager and Wi-Fi support
# --------------------------------------------------
echo "Setting up network services..."

sudo apt install --no-install-recommends -y \
  network-manager \
  network-manager-gnome \
  wpasupplicant

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
