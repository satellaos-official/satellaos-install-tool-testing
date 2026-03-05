#!/bin/bash

sudo apt update

sudo apt install -y wget

sudo apt install -y papirus-icon-theme

wget -qO- https://git.io/papirus-folders-install | sh

papirus-folders -C violet --theme Papirus

sudo gtk-update-icon-cache -f /usr/share/icons/*
