#!/bin/bash
shopt -s nullglob

sudo mkdir -p /usr/share/SatellaOS/logo/

sudo cp ~/satellaos-installer/logo/*.{asc,png} /usr/share/SatellaOS/logo/

sudo chmod 655 /usr/share/SatellaOS/logo/*

mkdir -p ~/satella-picture

ln -s /usr/share/SatellaOS/logo ~/satella-picture/logo 2>/dev/null
