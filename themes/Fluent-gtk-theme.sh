#!/bin/bash

sudo apt update
sudo apt install -y git libsass1 sassc

git clone https://github.com/vinceliuice/Fluent-gtk-theme.git "$HOME/satellaos-installer/themes/Fluent-gtk-theme/"

cd $HOME/satellaos-installer/themes/Fluent-gtk-theme/ || exit

sudo ./install.sh --dest /usr/share/themes --theme all --tweaks solid

rm -rf $HOME/satellaos-installer/themes/Fluent-gtk-theme/