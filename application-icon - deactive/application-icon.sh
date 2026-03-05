#!/bin/bash
shopt -s nullglob

sudo mkdir -p /usr/share/SatellaOS/application-icon/

sudo cp ~/satellaos-installer/application-icon/*.{jpg,png} /usr/share/SatellaOS/application-icon/

sudo chmod 655 /usr/share/SatellaOS/application-icon/*

mkdir -p ~/satella-picture

ln -s /usr/share/SatellaOS/application-icon ~/satella-picture/application-icon 2>/dev/null
