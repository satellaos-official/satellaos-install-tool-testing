#!/bin/bash
sudo mkdir -p /usr/share/SatellaOS/logo/

for dir in ~/satellaos-install-tool/logo/*/; do
    dir_name=$(basename "$dir")
    sudo cp -r "$dir" /usr/share/SatellaOS/logo/
    sudo find /usr/share/SatellaOS/logo/"$dir_name" -name "*.sh" -delete
done

sudo chmod -R 655 /usr/share/SatellaOS/logo/
mkdir -p ~/satella-picture
ln -s /usr/share/SatellaOS/logo ~/satella-picture/logo 2>/dev/null