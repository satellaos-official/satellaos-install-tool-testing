#!/bin/bash

set -e
set -u

if ! command -v whiptail &>/dev/null; then
    sudo apt install -y whiptail
fi

VERSION="5.3.0"

CHOICES=$(whiptail --title "SatellaOS Installer v$VERSION" \
    --checklist "Select the programs you want to install:\n(SPACE to mark, ENTER to confirm, TAB to switch between OK/Cancel)" \
    40 70 30 \
    "1"  "Brave Browser (Deb)"                                   OFF \
    "2"  "Chromium Browser (Deb)"                                OFF \
    "3"  "Firefox ESR (Deb)"                                     OFF \
    "4"  "Firefox (Portable)"                                    OFF \
    "5"  "Floorp Browser (Portable)"                             OFF \
    "6"  "Google Chrome (Deb)"                                   OFF \
    "7"  "Opera Stable (Deb)"                                    OFF \
    "8"  "Tor Browser (Deb)"                                     OFF \
    "9"  "Vivaldi Stable (Deb)"                                  OFF \
    "10" "Waterfox (Portable)"                                   OFF \
    "11" "Zen Browser (Portable)"                                OFF \
    "12" "Baobab Disk Usage Analyzer (Deb)"                      OFF \
    "13" "Bitwarden (Flatpak)"                                   OFF \
    "14" "BleachBit (Deb)"                                       OFF \
    "15" "Discord (Flatpak)"                                     OFF \
    "16" "Engrampa Archive Manager - Recommended (Deb)"          OFF \
    "17" "File Roller Archive Manager (Deb)"                     OFF \
    "18" "Flatseal - Recommended (Flatpak)"                      OFF \
    "19" "Free Download Manager (Deb)"                           OFF \
    "20" "Galculator - Recommended (Deb)"                        OFF \
    "21" "Gdebi Deb Installer - Recommended (Deb)"               OFF \
    "22" "GIMP (Deb)"                                            OFF \
    "23" "GIMP (Flatpak)"                                        OFF \
    "24" "Gnome Characters - Recommended (Deb)"                  OFF \
    "25" "Gnome Disk Utility (Deb)"                              OFF \
    "26" "Gnome Software - Recommended (Deb)"                    OFF \
    "27" "GParted (Deb)"                                         OFF \
    "28" "Grub Customizer (Deb)"                                 OFF \
    "29" "Gucharmap (Deb)"                                       OFF \
    "30" "Heroic Games Launcher (Deb)"                           OFF \
    "31" "Heroic Games Launcher (Flatpak)"                       OFF \
    "32" "Inkscape (Deb)"                                        OFF \
    "33" "KDiskMark (Deb)"                                       OFF \
    "34" "KDiskMark (Flatpak)"                                   OFF \
    "35" "KeePassXC (Deb)"                                       OFF \
    "36" "Krita (Flatpak)"                                       OFF \
    "37" "Libre Office (Deb)"                                    OFF \
    "38" "LightDM Settings (Deb)"                                OFF \
    "39" "LocalSend (Deb)"                                       OFF \
    "40" "LocalSend (Flatpak)"                                   OFF \
    "41" "Lutris (Deb)"                                          OFF \
    "42" "Lutris (Flatpak)"                                      OFF \
    "43" "MenuLibre (Deb)"                                       OFF \
    "44" "Mintstick (Deb)"                                       OFF \
    "45" "Mission Center - Recommended (Flatpak)"                OFF \
    "46" "Mousepad - Recommended (Deb)"                          OFF \
    "47" "OBS Studio (Flatpak)"                                  OFF \
    "48" "Obsidian (Flatpak)"                                    OFF \
    "49" "Onboard Screen Keyboard (Deb)"                         OFF \
    "50" "Pinta (Flatpak)"                                       OFF \
    "51" "PowerISO (Flatpak)"                                    OFF \
    "52" "qBittorrent (Deb)"                                     OFF \
    "53" "qemu with graphical (Deb)"                             OFF \
    "54" "qemu with terminal (Deb)"                              OFF \
    "55" "Ristretto Image Viewer - Recommended (Deb)"            OFF \
    "56" "Signal (Deb)"                                          OFF \
    "57" "Steam (Deb)"                                           OFF \
    "58" "Sublime Text (Deb)"                                    OFF \
    "59" "Telegram (Flatpak)"                                    OFF \
    "60" "Thunderbird (Deb)"                                     OFF \
    "61" "Timeshift (Deb)"                                       OFF \
    "62" "Unrar nonfree - Recommended (Deb)"                     OFF \
    "63" "VirtualBox [Debian 13 (Deb)]"                          OFF \
    "64" "VLC - Recommended (Deb)"                               OFF \
    "65" "VS Code (Deb)"                                         OFF \
    "66" "Warp VPN"                                              OFF \
    "67" "WineHQ Stable [Debian 13 (Deb)]"                       OFF \
    "68" "Wireshark (Deb)"                                       OFF \
    "69" "Xarchiver Archive Manager (Deb)"                       OFF \
    "70" "XFCE4 Appfinder (Deb)"                                 OFF \
    "71" "XFCE4 Screenshooter (Deb)"                             OFF \
    3>&1 1>&2 2>&3)

# Exit if the user pressed Cancel
if [ $? -ne 0 ]; then
    echo "Cancelled. Exiting."
    exit 0
fi

# Remove quotes and duplicates
SELECTIONS=$(echo "$CHOICES" | tr -d '"' | tr ' ' '\n' | sort -u)

if [[ -z "$SELECTIONS" ]]; then
    whiptail --title "SatellaOS Installer" --msgbox "No program selected. Exiting." 8 40
    exit 0
fi

# ── Confirmation screen ──
CONFIRM_LIST=$(echo "$SELECTIONS" | tr '\n' ' ')
whiptail --title "Confirmation" --yesno "The following numbered programs will be installed:\n\n$CONFIRM_LIST\n\nDo you want to continue?" 15 60
if [ $? -ne 0 ]; then
    echo "Cancelled."
    exit 0
fi

PKG_DIR=$(mktemp -d /tmp/satellaos-install-tool-XXXXXX)
trap 'rm -rf "$PKG_DIR"' EXIT

# ── 1 ── Brave Browser
install_1() {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources \
        https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update
    sudo apt install -y brave-browser
}

# ── 2 ── Chromium Browser
install_2() {
    sudo apt install -y chromium
}

# ── 3 ── Firefox ESR
install_3() {
    sudo apt install -y firefox-esr
}

# ── 4 ── Firefox (Portable)
install_4() {
    LATEST_VERSION=$(curl -s https://product-details.mozilla.org/1.0/firefox_versions.json | grep -Po '"LATEST_FIREFOX_VERSION":\s*"\K[^"]+')
    FILE="$PKG_DIR/firefox-$LATEST_VERSION.tar.xz"
    URL="https://ftp.mozilla.org/pub/firefox/releases/$LATEST_VERSION/linux-x86_64/en-US/firefox-$LATEST_VERSION.tar.xz"

    wget -O "$FILE" "$URL"
    sudo rm -rf /opt/firefox
    tar -xf "$FILE" -C "$PKG_DIR"
    sudo mv "$PKG_DIR/firefox" /opt/firefox
    sudo ln -sf /opt/firefox/firefox /usr/local/bin/firefox

    sudo tee /usr/share/applications/firefox.desktop > /dev/null <<EOL
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Mozilla Firefox Web Browser
Exec=/opt/firefox/firefox %u
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=firefox
EOL
    update-desktop-database /usr/share/applications 2>/dev/null || true
    xdg-mime default firefox.desktop x-scheme-handler/http
    xdg-mime default firefox.desktop x-scheme-handler/https
    xdg-settings set default-web-browser firefox.desktop
}

# ── 5 ── Floorp Browser (Portable)
install_5() {
    REPO="Floorp-Projects/Floorp"
    ASSET_NAME="floorp-linux-x86_64.tar.xz"

    LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
        | grep -oP '"tag_name": "\K(.*)(?=")')
    [ -z "$LATEST_TAG" ] && return 1

    FILE="$PKG_DIR/floorp.tar.xz"
    DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_TAG/$ASSET_NAME"
    wget -O "$FILE" "$DOWNLOAD_URL"

    sudo rm -rf /opt/floorp
    tar -xf "$FILE" -C "$PKG_DIR"
    DIR_NAME=$(tar -tf "$FILE" | head -1 | cut -f1 -d"/")
    sudo mv "$PKG_DIR/$DIR_NAME" /opt/floorp
    sudo ln -sf /opt/floorp/floorp /usr/local/bin/floorp

    ICON_PATH="/opt/floorp/browser/chrome/icons/default/default128.png"

    sudo tee /usr/share/applications/floorp.desktop > /dev/null <<EOL
[Desktop Entry]
Version=1.0
Name=Floorp Browser
Comment=Floorp Web Browser
Exec=/opt/floorp/floorp %u
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=floorp
EOL

    update-desktop-database /usr/share/applications 2>/dev/null || true
    xdg-mime default floorp.desktop x-scheme-handler/http
    xdg-mime default floorp.desktop x-scheme-handler/https
    xdg-settings set default-web-browser floorp.desktop
}

# ── 6 ── Google Chrome
install_6() {
    wget -O "$PKG_DIR/google-chrome-stable_current_amd64.deb" \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y "$PKG_DIR/google-chrome-stable_current_amd64.deb"
}

# ── 7 ── Opera Stable
install_7() {
    wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/opera-browser.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" \
        | sudo tee /etc/apt/sources.list.d/opera-archive.list
    sudo apt-get update
    sudo apt-get install -y opera-stable
}

# ── 8 ── Tor Browser
install_8() {
    sudo apt install -y torbrowser-launcher
    torbrowser-launcher
}

# ── 9 ── Vivaldi Stable
install_9() {
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub \
        | gpg --dearmor | sudo tee /usr/share/keyrings/vivaldi-browser.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" \
        | sudo tee /etc/apt/sources.list.d/vivaldi-archive.list
    sudo apt update
    sudo apt install -y vivaldi-stable
}

# ── 10 ── Waterfox (Portable)
install_10() {
    WATERFOX_VERSION="6.5.0"
    FILE="$PKG_DIR/waterfox-$WATERFOX_VERSION.tar.bz2"
    URL="https://cdn.waterfox.com/waterfox/releases/$WATERFOX_VERSION/Linux_x86_64/waterfox-$WATERFOX_VERSION.tar.bz2"

    wget -O "$FILE" "$URL"
    sudo rm -rf /opt/waterfox
    tar -xjf "$FILE" -C "$PKG_DIR"
    sudo mv "$PKG_DIR/waterfox" /opt/waterfox
    sudo ln -sf /opt/waterfox/waterfox /usr/local/bin/waterfox

    ICON_PATH="/opt/waterfox/browser/chrome/icons/default/default128.png"

    sudo tee /usr/share/applications/waterfox.desktop > /dev/null <<EOL
[Desktop Entry]
Version=1.0
Name=Waterfox
Comment=Waterfox Web Browser
Exec=/opt/waterfox/waterfox %u
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=waterfox
EOL

    update-desktop-database /usr/share/applications 2>/dev/null || true
    xdg-mime default waterfox.desktop x-scheme-handler/http
    xdg-mime default waterfox.desktop x-scheme-handler/https
    xdg-settings set default-web-browser waterfox.desktop
}

# ── 11 ── Zen Browser (Portable)
install_11() {
    FILE="$PKG_DIR/zen.linux-x86_64.tar.xz"
    wget -O "$FILE" https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz

    sudo rm -rf /opt/zen-browser
    tar -xf "$FILE" -C "$PKG_DIR"
    sudo mv "$PKG_DIR/zen" /opt/zen-browser

    BIN_PATH="/opt/zen-browser/zen"
    sudo ln -sf "$BIN_PATH" /usr/local/bin/zen-browser

    ICON_PATH="/opt/zen-browser/browser/chrome/icons/default/default128.png"

    sudo tee /usr/share/applications/zen-browser.desktop > /dev/null <<EOL
[Desktop Entry]
Version=1.0
Name=Zen Browser
Comment=Zen Web Browser
Exec=$BIN_PATH %u
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=zen
EOL

    update-desktop-database /usr/share/applications 2>/dev/null || true
    xdg-mime default zen-browser.desktop x-scheme-handler/http
    xdg-mime default zen-browser.desktop x-scheme-handler/https
    xdg-settings set default-web-browser zen-browser.desktop
}

# ── 12 ── Baobab Disk Usage Analyzer (Deb)
install_12() {
    sudo apt install -y baobab
}

# ── 13 ── Bitwarden (Flatpak)
install_13() {
    flatpak install -y --noninteractive flathub com.bitwarden.desktop
}

# ── 14 ── BleachBit (Deb)
install_14() {
    sudo apt install -y bleachbit
}

# ── 15 ── Discord (Flatpak)
install_15() {
    flatpak install flathub com.discordapp.Discord
}

# ── 16 ── Engrampa Archive Manager (Deb)
install_16() {
    sudo apt install -y engrampa
}

# ── 17 ── File Roller Archive Manager (Deb)
install_17() {
    sudo apt install -y file-roller
}

# ── 18 ── Flatseal (Flatpak)
install_18() {
    flatpak install -y --noninteractive flathub com.github.tchx84.Flatseal
}

# ── 19 ── Free Download Manager (Deb)
install_19() {
    wget -O "$PKG_DIR/freedownloadmanager.deb" \
        https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb
    sudo apt install -y "$PKG_DIR/freedownloadmanager.deb"
}

# ── 20 ── Galculator (Deb)
install_20() {
    sudo apt install -y galculator
}

# ── 21 ── Gdebi Deb Installer (Deb)
install_21() {
    sudo apt install -y gdebi
}

# ── 22 ── GIMP (Deb)
install_22() {
    sudo apt install -y gimp
}

# ── 23 ── GIMP (Flatpak)
install_23() {
    flatpak install -y --noninteractive flathub org.gimp.GIMP
}

# ── 24 ── Gnome Characters - Recommended (Deb)
install_24() {
    sudo apt install -y gnome-characters
}

# ── 25 ── Gnome Disk Utility (Deb)
install_25() {
    sudo apt install -y gnome-disk-utility
}

# ── 26 ── Gnome Software (Deb)
install_26() {
    sudo apt install -y gnome-software gnome-software-plugin-flatpak
}

# ── 27 ── GParted (Deb)
install_27() {
    sudo apt install -y gparted
}

# ── 28 ── Grub Customizer (Deb)
install_28() {
    sudo apt install -y grub-customizer
}

# ── 29 ── Gucharmap (Deb)
install_29() {
    sudo apt install -y gucharmap
}

# ── 30 ── Heroic Games Launcher (Deb)
install_30() {
    HEROIC_URL=$(curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest \
        | grep "browser_download_url" | grep "linux-amd64.deb" | cut -d '"' -f 4)
    HEROIC_FILE=$(basename "$HEROIC_URL")
    wget -O "$PKG_DIR/$HEROIC_FILE" "$HEROIC_URL"
    sudo apt install -y "$PKG_DIR/$HEROIC_FILE"
}

# ── 31 ── Heroic Games Launcher (Flatpak)
install_31() {
    flatpak install -y --noninteractive flathub com.heroicgameslauncher.hgl
}

# ── 32 ── Inkscape (Deb)
install_32() {
    sudo apt install -y inkscape
}

# ── 33 ── KDiskMark (Deb)
install_33() {
    KDISKMARK_URL=$(curl -s https://api.github.com/repos/JonMagon/KDiskMark/releases/latest \
        | grep "browser_download_url" | grep "amd64.deb" | cut -d '"' -f 4)
    KDISKMARK_FILE=$(basename "$KDISKMARK_URL")
    wget -O "$PKG_DIR/$KDISKMARK_FILE" "$KDISKMARK_URL"
    sudo apt install -y "$PKG_DIR/$KDISKMARK_FILE"
}

# ── 34 ── KDiskMark (Flatpak)
install_34() {
    flatpak install -y --noninteractive flathub io.github.jonmagon.kdiskmark
}

# ── 35 ── KeePassXC (Deb)
install_35() {
    sudo apt install -y keepassxc
}

# ── 36 ── Krita (Flatpak)
install_36() {
    flatpak install -y --noninteractive flathub org.kde.krita
}

# ── 37 ── Libre Office (Deb)
install_37() {
    sudo apt install -y libreoffice libreoffice-gtk3
}

# ── 38 ── LightDM Settings (Deb)
install_38() {
    sudo apt install -y lightdm-settings
}

# ── 39 ── LocalSend (Deb)
install_39() {
    LOCALSEND_URL=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest \
        | grep "browser_download_url" | grep "linux-x86-64.deb" | cut -d '"' -f 4)
    LOCALSEND_FILE=$(basename "$LOCALSEND_URL")
    wget -O "$PKG_DIR/$LOCALSEND_FILE" "$LOCALSEND_URL"
    sudo apt install -y "$PKG_DIR/$LOCALSEND_FILE"
}

# ── 40 ── LocalSend (Flatpak)
install_40() {
    flatpak install -y --noninteractive flathub org.localsend.localsend_app
}

# ── 41 ── Lutris (Deb)
install_41() {
    echo -e "Types: deb\nURIs: https://download.opensuse.org/repositories/home:/strycore:/lutris/Debian_13/\nSuites: ./\nComponents: \nSigned-By: /etc/apt/keyrings/lutris.gpg" \
        | sudo tee /etc/apt/sources.list.d/lutris.sources > /dev/null
    wget -q -O- https://download.opensuse.org/repositories/home:/strycore:/lutris/Debian_13/Release.key \
        | sudo gpg --dearmor -o /etc/apt/keyrings/lutris.gpg
    sudo apt update
    sudo apt install -y lutris
}

# ── 42 ── Lutris (Flatpak)
install_42() {
    flatpak install -y --noninteractive flathub net.lutris.Lutris
}

# ── 43 ── MenuLibre (Deb)
install_43() {
    sudo apt install -y menulibre
}

# ── 44 ── Mintstick (Deb)
install_44() {
    sudo apt install -y mintstick
}

# ── 45 ── Mission Center (Flatpak)
install_45() {
    flatpak install -y --noninteractive flathub io.missioncenter.MissionCenter
}

# ── 46 ── Mousepad Text Editor (Deb)
install_46() {
    sudo apt install -y mousepad
}

# ── 47 ── OBS Studio (Flatpak)
install_47() {
    flatpak install -y --noninteractive flathub com.obsproject.Studio
}

# ── 48 ── Obsidian (Flatpak)
install_48() {
    flatpak install -y --noninteractive flathub md.obsidian.Obsidian
}

# ── 49 ── Onboard Screen Keyboard (Deb)
install_49() {
    sudo apt install -y onboard
}

# ── 50 ── Pinta (Flatpak)
install_50() {
    flatpak install -y --noninteractive flathub com.github.PintaProject.Pinta
}

# ── 51 ── PowerISO (Flatpak)
install_51() {
    flatpak install -y --noninteractive flathub com.poweriso.PowerISO
}

# ── 52 ── qBittorrent (Deb)
install_52() {
    sudo apt install -y qbittorrent
}

# ── 53 ── qemu with graphical (Deb)
install_53() {
    sudo apt install -y qemu-system-x86 qemu-utils qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
    sudo virsh net-autostart default
}

# ── 54 ── qemu with terminal (Deb)
install_54() {
    sudo apt install -y qemu-system-x86 qemu-utils qemu-kvm
    sudo virsh net-autostart default
}

# ── 55 ── Ristretto Image Viewer (Deb)
install_55() {
    sudo apt install -y ristretto \
        libwebp7 \
        tumbler \
        tumbler-plugins-extra \
        webp-pixbuf-loader
}

# ── 56 ── Signal (Deb)
install_56() {
    wget -qO- https://updates.signal.org/desktop/apt/keys.asc \
        | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
https://updates.signal.org/desktop/apt xenial main" \
        | sudo tee /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update
    sudo apt install -y signal-desktop
}

# ── 57 ── Steam (Deb)
install_57() {
    wget -O "$PKG_DIR/steam_latest.deb" \
        https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
    sudo apt install -y "$PKG_DIR/steam_latest.deb"
}

# ── 58 ── Sublime Text (Deb)
install_58() {
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
        | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e "Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc" \
        | sudo tee /etc/apt/sources.list.d/sublime-text.sources
    sudo apt update
    sudo apt install -y sublime-text
}

# ── 59 ── Telegram (Flatpak)
install_59() {
    flatpak install -y --noninteractive flathub org.telegram.desktop
}

# ── 60 ── Thunderbird (Deb)
install_60() {
    sudo apt install -y thunderbird
}

# ── 61 ── Timeshift (Deb)
install_61() {
    sudo apt install -y timeshift
}

# ── 62 ── Unrar nonfree (Deb)
install_62() {
    sudo apt install -y unrar
}

# ── 63 ── VirtualBox [Debian 13 (Deb)]
install_63() {
    wget -O oracle_vbox_2016.asc https://www.virtualbox.org/download/oracle_vbox_2016.asc
    sudo gpg --yes --output /usr/share/keyrings/oracle_vbox_2016.gpg --dearmor oracle_vbox_2016.asc
    sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null <<EOF
deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] https://download.virtualbox.org/virtualbox/debian trixie contrib
EOF
    sudo apt-get update
    sudo apt-get install -y virtualbox-7.2
    sudo usermod -aG vboxusers "$USER"

    FULL_VERSION=$(dpkg-query -W -f='${Version}' virtualbox-7.2)
    VBOX_VERSION=$(echo "$FULL_VERSION" | cut -d '-' -f1)
    VBOX_BUILD=$(echo "$FULL_VERSION" | cut -d '-' -f2 | cut -d '~' -f1)

    EXT_PACK_FILE="/tmp/Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}-${VBOX_BUILD}.vbox-extpack"
    EXT_PACK_URL="https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}-${VBOX_BUILD}.vbox-extpack"

    wget -O "$EXT_PACK_FILE" "$EXT_PACK_URL"
    echo y | sudo VBoxManage extpack install --replace "$EXT_PACK_FILE"
    rm -f "$EXT_PACK_FILE"
}

# ── 64 ── VLC (Deb)
install_64() {
    sudo apt install -y vlc
}

# ── 65 ── VS Code (Deb)
install_65() {
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] \
https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update
    sudo apt install -y code
}

# ── 66 ── Warp VPN
install_66() {
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg \
        | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
    sudo apt-get update && sudo apt-get install -y cloudflare-warp
}

# ── 67 ── WineHQ Stable [Debian 13 (Deb)]
install_67() {
    sudo mkdir -pm755 /etc/apt/keyrings
    wget -O - https://dl.winehq.org/wine-builds/winehq.key \
        | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
    sudo dpkg --add-architecture i386
    sudo wget -NP /etc/apt/sources.list.d/ \
        https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources
    sudo apt update
    sudo apt install -y --install-recommends winehq-stable
}

# ── 68 ── Wireshark (Deb)
install_68() {
    sudo apt install -y wireshark
}

# ── 69 ── Xarchiver (Deb)
install_69() {
    sudo apt install -y xarchiver
}

# ── 70 ── XFCE4 Appfinder (Deb)
install_70() {
    sudo apt install -y xfce4-appfinder
}

# ── 71 ── XFCE4 Screenshooter (Deb)
install_71() {
    sudo apt install -y xfce4-screenshooter
}

# ────────────────────────────────────────────
TOTAL=$(echo "$SELECTIONS" | wc -w)
CURRENT=0

for i in $SELECTIONS; do
    CURRENT=$((CURRENT + 1))
    if declare -f "install_$i" >/dev/null; then
        echo "[$CURRENT/$TOTAL] Installing program $i..."
        install_$i && echo "[$CURRENT/$TOTAL] Program $i installed ✓" || echo "[$CURRENT/$TOTAL] ERROR occurred while installing program $i ✗"
    else
        echo "[$CURRENT/$TOTAL] Invalid selection: $i, skipping."
    fi
done
