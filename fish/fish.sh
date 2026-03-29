#!/bin/bash
set -e

# Fish'i kur
sudo apt install -y fish

# Fish yolunu bul
FISH_PATH="$(which fish)"

# /etc/shells'e ekle (yoksa)
if ! grep -qxF "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Varsayılan shell olarak ayarla
sudo chsh -s "$FISH_PATH" root
chsh -s "$FISH_PATH"

echo "✅ Fish shell varsayılan olarak ayarlandı: $FISH_PATH"
echo "🔁 Değişikliğin geçerli olması için yeniden giriş yapın."