#!/usr/bin/env bash
set -euo pipefail

CONF="/etc/sysctl.d/99-silent-kernel.conf"

echo "Configuring kernel printk..."
echo "kernel.printk = 1 4 1 7" | sudo tee "$CONF" >/dev/null

echo "Reloading sysctl settings..."
sudo sysctl --system

echo "Done."