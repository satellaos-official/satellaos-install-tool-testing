#!/bin/bash
shopt -s nullglob

sudo mkdir -p /usr/share/SatellaOS/backgrounds/

sudo cp ~/satellaos-installer/backgrounds/*.{jpg,png} /usr/share/SatellaOS/backgrounds/

sudo chmod 655 /usr/share/SatellaOS/backgrounds/*

mkdir -p ~/satella-picture

ln -s /usr/share/SatellaOS/backgrounds ~/satella-picture/backgrounds 2>/dev/null
