#!/bin/bash

if [[ ! -f ~/satellaos-install-tool/grub/grub ]]; then
    exit 1
fi

sudo cp ~/satellaos-install-tool/grub/grub /etc/default/grub
sudo update-grub
sudo update-initramfs -u
