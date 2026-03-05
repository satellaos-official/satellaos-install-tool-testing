#!/bin/bash

if [[ ! -f ~/satellaos-installer/grub/grub ]]; then
    exit 1
fi

sudo cp ~/satellaos-installer/grub/grub /etc/default/grub
sudo update-grub
sudo update-initramfs -u
