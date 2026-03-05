#!/usr/bin/env python3
# SatellaOS Installer - GTK3 GUI
# Depends: python3-gi, gir1.2-gtk-3.0

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib, Gdk, Pango

import subprocess
import threading
import sys
import os

VERSION = "5.3.0"

# ── CSS Theme (Debian-like dark blue) ──────────────────────────────────────
CSS = b"""
* {
    font-family: 'DejaVu Sans', sans-serif;
    font-size: 13px;
}

window {
    background-color: #1a1a2e;
}

#header {
    background-color: #16213e;
    border-bottom: 2px solid #0f3460;
    padding: 16px 24px;
}

#header-title {
    color: #e94560;
    font-size: 20px;
    font-weight: bold;
    letter-spacing: 1px;
}

#header-subtitle {
    color: #a0aec0;
    font-size: 12px;
    margin-top: 2px;
}

#sidebar {
    background-color: #16213e;
    border-right: 1px solid #0f3460;
    padding: 8px 0;
    min-width: 200px;
}

#sidebar-item {
    color: #a0aec0;
    padding: 10px 20px;
    font-size: 12px;
    border: none;
    background: transparent;
}

#sidebar-item-active {
    color: #ffffff;
    background-color: #0f3460;
    padding: 10px 20px;
    font-size: 12px;
    font-weight: bold;
    border-left: 3px solid #e94560;
}

#sidebar-item-done {
    color: #48bb78;
    padding: 10px 20px;
    font-size: 12px;
}

#content {
    background-color: #1a1a2e;
    padding: 32px 40px;
}

#page-title {
    color: #ffffff;
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 6px;
}

#page-desc {
    color: #a0aec0;
    font-size: 12px;
    margin-bottom: 24px;
}

#divider {
    background-color: #0f3460;
    min-height: 1px;
    margin-bottom: 24px;
}

#category-label {
    color: #e94560;
    font-size: 11px;
    font-weight: bold;
    letter-spacing: 1px;
    margin-top: 12px;
    margin-bottom: 4px;
}

#pkg-row {
    background-color: #16213e;
    border-radius: 6px;
    padding: 2px 8px;
    margin-bottom: 2px;
}

#pkg-row:hover {
    background-color: #0f3460;
}

#pkg-name {
    color: #e2e8f0;
    font-size: 13px;
}

#pkg-type {
    color: #718096;
    font-size: 11px;
}

#footer {
    background-color: #16213e;
    border-top: 1px solid #0f3460;
    padding: 12px 24px;
}

#btn-back {
    background-color: transparent;
    color: #a0aec0;
    border: 1px solid #4a5568;
    border-radius: 4px;
    padding: 8px 20px;
    font-size: 13px;
}

#btn-back:hover {
    background-color: #2d3748;
    color: #ffffff;
}

#btn-next {
    background-color: #e94560;
    color: #ffffff;
    border: none;
    border-radius: 4px;
    padding: 8px 24px;
    font-size: 13px;
    font-weight: bold;
}

#btn-next:hover {
    background-color: #c53050;
}

#btn-next:disabled {
    background-color: #4a5568;
    color: #718096;
}

#progress-bar {
    min-height: 18px;
    border-radius: 4px;
}

#progress-bar trough {
    background-color: #2d3748;
    border-radius: 4px;
}

#progress-bar progress {
    background-color: #e94560;
    border-radius: 4px;
}

#log-view {
    background-color: #0d1117;
    color: #48bb78;
    font-family: 'DejaVu Sans Mono', monospace;
    font-size: 11px;
    padding: 8px;
    border-radius: 4px;
}

#status-label {
    color: #e2e8f0;
    font-size: 13px;
    font-weight: bold;
}

#step-label {
    color: #a0aec0;
    font-size: 11px;
}

#summary-success {
    color: #48bb78;
    font-size: 15px;
    font-weight: bold;
}

#summary-fail {
    color: #e94560;
    font-size: 13px;
}

checkbutton {
    color: #e2e8f0;
}

checkbutton check {
    background-color: #2d3748;
    border: 1px solid #4a5568;
    border-radius: 3px;
}

checkbutton:checked check {
    background-color: #e94560;
    border-color: #e94560;
}
"""

# ── Package definitions ─────────────────────────────────────────────────────
CATEGORIES = [
    ("🌐  Browsers", [
        (1,  "Brave Browser",              "Deb"),
        (2,  "Chromium",                   "Deb"),
        (3,  "Firefox ESR",                "Deb"),
        (4,  "Firefox",                    "Portable"),
        (5,  "Floorp Browser",             "Portable"),
        (6,  "Google Chrome",              "Deb"),
        (7,  "Opera Stable",               "Deb"),
        (8,  "Tor Browser",                "Deb"),
        (9,  "Vivaldi Stable",             "Deb"),
        (10, "Waterfox",                   "Portable"),
        (11, "Zen Browser",                "Portable"),
    ]),
    ("🔒  Security & Privacy", [
        (13, "Bitwarden",                  "Flatpak"),
        (35, "KeePassXC",                  "Deb"),
        (56, "Signal",                     "Deb"),
        (66, "Warp VPN",                   "Deb"),
        (68, "Wireshark",                  "Deb"),
    ]),
    ("💬  Communication", [
        (15, "Discord",                    "Flatpak"),
        (59, "Telegram",                   "Flatpak"),
        (60, "Thunderbird",                "Deb"),
    ]),
    ("🎮  Gaming", [
        (30, "Heroic Games Launcher",      "Deb"),
        (31, "Heroic Games Launcher",      "Flatpak"),
        (41, "Lutris",                     "Deb"),
        (42, "Lutris",                     "Flatpak"),
        (57, "Steam",                      "Deb"),
        (63, "VirtualBox",                 "Deb"),
        (67, "WineHQ Stable",              "Deb"),
    ]),
    ("🎨  Graphics & Media", [
        (22, "GIMP",                       "Deb"),
        (23, "GIMP",                       "Flatpak"),
        (32, "Inkscape",                   "Deb"),
        (36, "Krita",                      "Flatpak"),
        (47, "OBS Studio",                 "Flatpak"),
        (50, "Pinta",                      "Flatpak"),
        (55, "Ristretto Image Viewer",     "Deb"),
        (64, "VLC",                        "Deb"),
    ]),
    ("🛠️  System Tools", [
        (12, "Baobab Disk Analyzer",       "Deb"),
        (14, "BleachBit",                  "Deb"),
        (18, "Flatseal",                   "Flatpak"),
        (25, "Gnome Disk Utility",         "Deb"),
        (26, "Gnome Software",             "Deb"),
        (27, "GParted",                    "Deb"),
        (28, "Grub Customizer",            "Deb"),
        (33, "KDiskMark",                  "Deb"),
        (34, "KDiskMark",                  "Flatpak"),
        (38, "LightDM Settings",           "Deb"),
        (45, "Mission Center",             "Flatpak"),
        (51, "PowerISO",                   "Flatpak"),
        (61, "Timeshift",                  "Deb"),
    ]),
    ("📁  Files & Office", [
        (16, "Engrampa Archive Manager",   "Deb"),
        (17, "File Roller",                "Deb"),
        (19, "Free Download Manager",      "Deb"),
        (37, "LibreOffice",                "Deb"),
        (39, "LocalSend",                  "Deb"),
        (40, "LocalSend",                  "Flatpak"),
        (44, "Mintstick",                  "Deb"),
        (52, "qBittorrent",                "Deb"),
        (62, "Unrar",                      "Deb"),
        (69, "Xarchiver",                  "Deb"),
    ]),
    ("✏️  Editors & Dev", [
        (48, "Obsidian",                   "Flatpak"),
        (58, "Sublime Text",               "Deb"),
        (65, "VS Code",                    "Deb"),
    ]),
    ("🖥️  Desktop & Accessories", [
        (20, "Galculator",                 "Deb"),
        (21, "Gdebi Deb Installer",        "Deb"),
        (24, "Gnome Characters",           "Deb"),
        (29, "Gucharmap",                  "Deb"),
        (43, "MenuLibre",                  "Deb"),
        (46, "Mousepad",                   "Deb"),
        (49, "Onboard Screen Keyboard",    "Deb"),
        (53, "qemu (Graphical)",           "Deb"),
        (54, "qemu (Terminal)",            "Deb"),
        (70, "XFCE4 Appfinder",            "Deb"),
        (71, "XFCE4 Screenshooter",        "Deb"),
    ]),
]

# ── Install commands ────────────────────────────────────────────────────────
INSTALL_STEPS = {
    1: {
        "name": "Brave Browser",
        "steps": [
            ("Adding GPG key",       "sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"),
            ("Adding repository",    "sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources"),
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y brave-browser"),
        ]
    },
    2: {
        "name": "Chromium",
        "steps": [
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y chromium"),
        ]
    },
    3: {
        "name": "Firefox ESR",
        "steps": [
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y firefox-esr"),
        ]
    },
    4: {
        "name": "Firefox (Portable)",
        "steps": [
            ("Fetching latest version", None),
            ("Downloading",             None),
            ("Extracting",              None),
            ("Creating desktop entry",  None),
            ("Setting as default",      None),
        ],
        "script": r"""
LATEST=$(curl -s https://product-details.mozilla.org/1.0/firefox_versions.json | grep -Po '"LATEST_FIREFOX_VERSION":\s*"\K[^"]+')
wget -q -O /tmp/firefox.tar.xz "https://ftp.mozilla.org/pub/firefox/releases/$LATEST/linux-x86_64/en-US/firefox-$LATEST.tar.xz"
sudo rm -rf /opt/firefox && tar -xf /tmp/firefox.tar.xz -C /tmp
sudo mv /tmp/firefox /opt/firefox
sudo ln -sf /opt/firefox/firefox /usr/local/bin/firefox
sudo tee /usr/share/applications/firefox.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Firefox
Exec=/opt/firefox/firefox %u
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOL
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
xdg-settings set default-web-browser firefox.desktop
"""
    },
    5: {
        "name": "Floorp Browser (Portable)",
        "steps": [
            ("Fetching latest release", None),
            ("Downloading",             None),
            ("Extracting",              None),
            ("Creating desktop entry",  None),
            ("Setting as default",      None),
        ],
        "script": r"""
LATEST=$(curl -s https://api.github.com/repos/Floorp-Projects/Floorp/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget -q -O /tmp/floorp.tar.xz "https://github.com/Floorp-Projects/Floorp/releases/download/$LATEST/floorp-linux-x86_64.tar.xz"
sudo rm -rf /opt/floorp && tar -xf /tmp/floorp.tar.xz -C /tmp
DIR=$(tar -tf /tmp/floorp.tar.xz | head -1 | cut -f1 -d"/")
sudo mv "/tmp/$DIR" /opt/floorp
sudo ln -sf /opt/floorp/floorp /usr/local/bin/floorp
sudo tee /usr/share/applications/floorp.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Floorp Browser
Exec=/opt/floorp/floorp %u
Icon=/opt/floorp/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOL
xdg-mime default floorp.desktop x-scheme-handler/http
xdg-mime default floorp.desktop x-scheme-handler/https
xdg-settings set default-web-browser floorp.desktop
"""
    },
    6: {
        "name": "Google Chrome",
        "steps": [
            ("Downloading", "wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"),
            ("Installing",  "sudo apt install -y /tmp/google-chrome.deb"),
        ]
    },
    7: {
        "name": "Opera Stable",
        "steps": [
            ("Adding GPG key",       "wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/opera-browser.gpg > /dev/null"),
            ("Adding repository",    """echo 'deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free' | sudo tee /etc/apt/sources.list.d/opera-archive.list"""),
            ("Updating package list","sudo apt-get update -qq"),
            ("Installing",           "sudo apt-get install -y opera-stable"),
        ]
    },
    8: {
        "name": "Tor Browser",
        "steps": [
            ("Installing launcher",  "sudo apt install -y torbrowser-launcher"),
            ("First-time setup",     "torbrowser-launcher"),
        ]
    },
    9: {
        "name": "Vivaldi Stable",
        "steps": [
            ("Adding GPG key",       "wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/vivaldi-browser.gpg > /dev/null"),
            ("Adding repository",    """echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi-archive.list"""),
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y vivaldi-stable"),
        ]
    },
    10: {
        "name": "Waterfox (Portable)",
        "steps": [
            ("Downloading",          "wget -q -O /tmp/waterfox.tar.bz2 https://cdn.waterfox.com/waterfox/releases/6.5.0/Linux_x86_64/waterfox-6.5.0.tar.bz2"),
            ("Extracting",           "sudo rm -rf /opt/waterfox && tar -xjf /tmp/waterfox.tar.bz2 -C /tmp && sudo mv /tmp/waterfox /opt/waterfox && sudo ln -sf /opt/waterfox/waterfox /usr/local/bin/waterfox"),
            ("Creating desktop entry",None),
            ("Setting as default",   None),
        ],
        "script": r"""
sudo tee /usr/share/applications/waterfox.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Waterfox
Exec=/opt/waterfox/waterfox %u
Icon=/opt/waterfox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOL
xdg-mime default waterfox.desktop x-scheme-handler/http
xdg-mime default waterfox.desktop x-scheme-handler/https
xdg-settings set default-web-browser waterfox.desktop
"""
    },
    11: {
        "name": "Zen Browser (Portable)",
        "steps": [
            ("Downloading",           "wget -q -O /tmp/zen.tar.xz https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz"),
            ("Extracting",            "sudo rm -rf /opt/zen-browser && tar -xf /tmp/zen.tar.xz -C /tmp && sudo mv /tmp/zen /opt/zen-browser && sudo ln -sf /opt/zen-browser/zen /usr/local/bin/zen-browser"),
            ("Creating desktop entry",None),
            ("Setting as default",    None),
        ],
        "script": r"""
sudo tee /usr/share/applications/zen-browser.desktop > /dev/null <<EOL
[Desktop Entry]
Name=Zen Browser
Exec=/opt/zen-browser/zen %u
Icon=/opt/zen-browser/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOL
xdg-mime default zen-browser.desktop x-scheme-handler/http
xdg-mime default zen-browser.desktop x-scheme-handler/https
xdg-settings set default-web-browser zen-browser.desktop
"""
    },
    12: {"name": "Baobab",               "steps": [("Installing", "sudo apt install -y baobab")]},
    13: {"name": "Bitwarden",             "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.bitwarden.desktop")]},
    14: {"name": "BleachBit",             "steps": [("Installing", "sudo apt install -y bleachbit")]},
    15: {"name": "Discord",               "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.discordapp.Discord")]},
    16: {"name": "Engrampa",              "steps": [("Installing", "sudo apt install -y engrampa")]},
    17: {"name": "File Roller",           "steps": [("Installing", "sudo apt install -y file-roller")]},
    18: {"name": "Flatseal",              "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.github.tchx84.Flatseal")]},
    19: {
        "name": "Free Download Manager",
        "steps": [
            ("Downloading", "wget -q -O /tmp/fdm.deb https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb"),
            ("Installing",  "sudo apt install -y /tmp/fdm.deb"),
        ]
    },
    20: {"name": "Galculator",            "steps": [("Installing", "sudo apt install -y galculator")]},
    21: {"name": "Gdebi Deb Installer",   "steps": [("Installing", "sudo apt install -y gdebi")]},
    22: {"name": "GIMP (Deb)",            "steps": [("Installing", "sudo apt install -y gimp")]},
    23: {"name": "GIMP (Flatpak)",        "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub org.gimp.GIMP")]},
    24: {"name": "Gnome Characters",      "steps": [("Installing", "sudo apt install -y gnome-characters")]},
    25: {"name": "Gnome Disk Utility",    "steps": [("Installing", "sudo apt install -y gnome-disk-utility")]},
    26: {"name": "Gnome Software",        "steps": [("Installing", "sudo apt install -y gnome-software gnome-software-plugin-flatpak")]},
    27: {"name": "GParted",              "steps": [("Installing", "sudo apt install -y gparted")]},
    28: {"name": "Grub Customizer",       "steps": [("Installing", "sudo apt install -y grub-customizer")]},
    29: {"name": "Gucharmap",             "steps": [("Installing", "sudo apt install -y gucharmap")]},
    30: {
        "name": "Heroic Games Launcher",
        "steps": [
            ("Fetching latest release", None),
            ("Downloading",             None),
            ("Installing",              None),
        ],
        "script": r"""
URL=$(curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest | grep browser_download_url | grep linux-amd64.deb | cut -d'"' -f4)
wget -q -O /tmp/heroic.deb "$URL"
sudo apt install -y /tmp/heroic.deb
"""
    },
    31: {"name": "Heroic Games Launcher (Flatpak)", "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.heroicgameslauncher.hgl")]},
    32: {"name": "Inkscape",              "steps": [("Installing", "sudo apt install -y inkscape")]},
    33: {
        "name": "KDiskMark",
        "steps": [
            ("Fetching latest release", None),
            ("Downloading",             None),
            ("Installing",              None),
        ],
        "script": r"""
URL=$(curl -s https://api.github.com/repos/JonMagon/KDiskMark/releases/latest | grep browser_download_url | grep amd64.deb | cut -d'"' -f4)
wget -q -O /tmp/kdiskmark.deb "$URL"
sudo apt install -y /tmp/kdiskmark.deb
"""
    },
    34: {"name": "KDiskMark (Flatpak)",   "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub io.github.jonmagon.kdiskmark")]},
    35: {"name": "KeePassXC",             "steps": [("Installing", "sudo apt install -y keepassxc")]},
    36: {"name": "Krita",                 "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub org.kde.krita")]},
    37: {"name": "LibreOffice",           "steps": [("Installing", "sudo apt install -y libreoffice libreoffice-gtk3")]},
    38: {"name": "LightDM Settings",      "steps": [("Installing", "sudo apt install -y lightdm-settings")]},
    39: {
        "name": "LocalSend",
        "steps": [
            ("Fetching latest release", None),
            ("Downloading",             None),
            ("Installing",              None),
        ],
        "script": r"""
URL=$(curl -s https://api.github.com/repos/localsend/localsend/releases/latest | grep browser_download_url | grep linux-x86-64.deb | cut -d'"' -f4)
wget -q -O /tmp/localsend.deb "$URL"
sudo apt install -y /tmp/localsend.deb
"""
    },
    40: {"name": "LocalSend (Flatpak)",   "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub org.localsend.localsend_app")]},
    41: {
        "name": "Lutris",
        "steps": [
            ("Adding repository",    None),
            ("Adding GPG key",       None),
            ("Updating package list",None),
            ("Installing",           None),
        ],
        "script": r"""
echo -e "Types: deb\nURIs: https://download.opensuse.org/repositories/home:/strycore:/lutris/Debian_13/\nSuites: ./\nComponents: \nSigned-By: /etc/apt/keyrings/lutris.gpg" | sudo tee /etc/apt/sources.list.d/lutris.sources > /dev/null
wget -q -O- https://download.opensuse.org/repositories/home:/strycore:/lutris/Debian_13/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/lutris.gpg
sudo apt update -qq
sudo apt install -y lutris
"""
    },
    42: {"name": "Lutris (Flatpak)",      "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub net.lutris.Lutris")]},
    43: {"name": "MenuLibre",             "steps": [("Installing", "sudo apt install -y menulibre")]},
    44: {"name": "Mintstick",             "steps": [("Installing", "sudo apt install -y mintstick")]},
    45: {"name": "Mission Center",        "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub io.missioncenter.MissionCenter")]},
    46: {"name": "Mousepad",             "steps": [("Installing", "sudo apt install -y mousepad")]},
    47: {"name": "OBS Studio",            "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.obsproject.Studio")]},
    48: {"name": "Obsidian",              "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub md.obsidian.Obsidian")]},
    49: {"name": "Onboard",              "steps": [("Installing", "sudo apt install -y onboard")]},
    50: {"name": "Pinta",                 "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.github.PintaProject.Pinta")]},
    51: {"name": "PowerISO",              "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub com.poweriso.PowerISO")]},
    52: {"name": "qBittorrent",           "steps": [("Installing", "sudo apt install -y qbittorrent")]},
    53: {
        "name": "qemu (Graphical)",
        "steps": [
            ("Installing", "sudo apt install -y qemu-system-x86 qemu-utils qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager"),
            ("Enabling default network", "sudo virsh net-autostart default"),
        ]
    },
    54: {
        "name": "qemu (Terminal)",
        "steps": [
            ("Installing", "sudo apt install -y qemu-system-x86 qemu-utils qemu-kvm"),
            ("Enabling default network", "sudo virsh net-autostart default"),
        ]
    },
    55: {"name": "Ristretto",             "steps": [("Installing", "sudo apt install -y ristretto libwebp7 tumbler tumbler-plugins-extra webp-pixbuf-loader")]},
    56: {
        "name": "Signal",
        "steps": [
            ("Adding GPG key",       "wget -qO- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null"),
            ("Adding repository",    """echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list"""),
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y signal-desktop"),
        ]
    },
    57: {
        "name": "Steam",
        "steps": [
            ("Downloading", "wget -q -O /tmp/steam.deb https://repo.steampowered.com/steam/archive/precise/steam_latest.deb"),
            ("Installing",  "sudo apt install -y /tmp/steam.deb"),
        ]
    },
    58: {
        "name": "Sublime Text",
        "steps": [
            ("Adding GPG key",       "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null"),
            ("Adding repository",    """echo -e "Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc" | sudo tee /etc/apt/sources.list.d/sublime-text.sources"""),
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y sublime-text"),
        ]
    },
    59: {"name": "Telegram",              "steps": [("Installing via Flatpak", "flatpak install -y --noninteractive flathub org.telegram.desktop")]},
    60: {"name": "Thunderbird",           "steps": [("Installing", "sudo apt install -y thunderbird")]},
    61: {"name": "Timeshift",             "steps": [("Installing", "sudo apt install -y timeshift")]},
    62: {"name": "Unrar",                 "steps": [("Installing", "sudo apt install -y unrar")]},
    63: {
        "name": "VirtualBox",
        "steps": [
            ("Adding GPG key",            None),
            ("Adding repository",         None),
            ("Updating package list",     None),
            ("Installing",                None),
            ("Downloading Extension Pack",None),
            ("Installing Extension Pack", None),
        ],
        "script": r"""
wget -q -O /tmp/oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo gpg --yes --output /usr/share/keyrings/oracle_vbox_2016.gpg --dearmor /tmp/oracle_vbox.asc
sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null <<EOF
deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] https://download.virtualbox.org/virtualbox/debian trixie contrib
EOF
sudo apt-get update -qq
sudo apt-get install -y virtualbox-7.2
sudo usermod -aG vboxusers "$USER"
FULL=$(dpkg-query -W -f='${Version}' virtualbox-7.2)
VER=$(echo "$FULL" | cut -d'-' -f1)
BLD=$(echo "$FULL" | cut -d'-' -f2 | cut -d'~' -f1)
EXT="/tmp/Oracle_VirtualBox_Extension_Pack-${VER}-${BLD}.vbox-extpack"
wget -q -O "$EXT" "https://download.virtualbox.org/virtualbox/${VER}/Oracle_VirtualBox_Extension_Pack-${VER}-${BLD}.vbox-extpack"
echo y | sudo VBoxManage extpack install --replace "$EXT"
rm -f "$EXT"
"""
    },
    64: {"name": "VLC",                   "steps": [("Installing", "sudo apt install -y vlc")]},
    65: {
        "name": "VS Code",
        "steps": [
            ("Adding GPG key",       "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg > /dev/null"),
            ("Adding repository",    """echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list"""),
            ("Updating package list","sudo apt update -qq"),
            ("Installing",           "sudo apt install -y code"),
        ]
    },
    66: {
        "name": "Warp VPN",
        "steps": [
            ("Adding GPG key",       "curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg"),
            ("Adding repository",    """echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list"""),
            ("Updating package list","sudo apt-get update -qq"),
            ("Installing",           "sudo apt-get install -y cloudflare-warp"),
        ]
    },
    67: {
        "name": "WineHQ Stable",
        "steps": [
            ("Creating keyring directory",  "sudo mkdir -pm755 /etc/apt/keyrings"),
            ("Adding GPG key",              "wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -"),
            ("Enabling 32-bit architecture","sudo dpkg --add-architecture i386"),
            ("Adding repository & updating","sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources && sudo apt update -qq"),
            ("Installing",                  "sudo apt install -y --install-recommends winehq-stable"),
        ]
    },
    68: {"name": "Wireshark",             "steps": [("Installing", "sudo apt install -y wireshark")]},
    69: {"name": "Xarchiver",             "steps": [("Installing", "sudo apt install -y xarchiver")]},
    70: {"name": "XFCE4 Appfinder",       "steps": [("Installing", "sudo apt install -y xfce4-appfinder")]},
    71: {"name": "XFCE4 Screenshooter",   "steps": [("Installing", "sudo apt install -y xfce4-screenshooter")]},
}

# ── Sidebar steps ───────────────────────────────────────────────────────────
SIDEBAR_STEPS = ["Welcome", "Select Software", "Confirm", "Installing", "Finish"]


class InstallerWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title=f"SatellaOS Installer v{VERSION}")
        self.set_default_size(900, 620)
        self.set_resizable(False)
        self.set_position(Gtk.WindowPosition.CENTER)

        # Apply CSS
        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.current_page = 0
        self.selected = set()
        self.checkboxes = {}
        self.errors = []

        self._build_ui()
        self.show_all()
        self._update_sidebar()
        self._show_page(0)

    # ── UI Layout ────────────────────────────────────────────────────────────
    def _build_ui(self):
        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.add(root)

        # Header
        header = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        header.set_name("header")
        title = Gtk.Label(label=f"SatellaOS Installer")
        title.set_name("header-title")
        title.set_halign(Gtk.Align.START)
        subtitle = Gtk.Label(label=f"Version {VERSION}  •  Debian-based system")
        subtitle.set_name("header-subtitle")
        subtitle.set_halign(Gtk.Align.START)
        header.pack_start(title, False, False, 0)
        header.pack_start(subtitle, False, False, 0)
        root.pack_start(header, False, False, 0)

        # Body (sidebar + content)
        body = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        root.pack_start(body, True, True, 0)

        # Sidebar
        self.sidebar = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.sidebar.set_name("sidebar")
        self.sidebar_labels = []
        for step in SIDEBAR_STEPS:
            lbl = Gtk.Label(label=step)
            lbl.set_halign(Gtk.Align.START)
            lbl.set_name("sidebar-item")
            self.sidebar.pack_start(lbl, False, False, 0)
            self.sidebar_labels.append(lbl)
        body.pack_start(self.sidebar, False, False, 0)

        # Content stack
        self.stack = Gtk.Stack()
        self.stack.set_name("content")
        self.stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        self.stack.set_transition_duration(200)
        body.pack_start(self.stack, True, True, 0)

        self.stack.add_named(self._build_welcome(), "welcome")
        self.stack.add_named(self._build_select(), "select")
        self.stack.add_named(self._build_confirm(), "confirm")
        self.stack.add_named(self._build_installing(), "installing")
        self.stack.add_named(self._build_finish(), "finish")

        # Footer
        footer = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        footer.set_name("footer")

        self.btn_back = Gtk.Button(label="← Back")
        self.btn_back.set_name("btn-back")
        self.btn_back.connect("clicked", self._on_back)

        self.btn_next = Gtk.Button(label="Next →")
        self.btn_next.set_name("btn-next")
        self.btn_next.connect("clicked", self._on_next)

        footer.pack_start(self.btn_back, False, False, 0)
        footer.pack_end(self.btn_next, False, False, 0)
        root.pack_start(footer, False, False, 0)

    # ── Pages ────────────────────────────────────────────────────────────────
    def _build_welcome(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_name("content")
        box.set_margin_top(60)
        box.set_margin_start(60)
        box.set_margin_end(60)

        icon = Gtk.Label(label="🚀")
        icon.set_name("page-title")
        ctx = icon.get_pango_context()
        desc = ctx.get_font_description()
        desc.set_size(48 * Pango.SCALE)
        icon.override_font(desc)
        icon.set_margin_bottom(20)

        title = Gtk.Label(label="Welcome to SatellaOS Installer")
        title.set_name("page-title")
        title.set_halign(Gtk.Align.CENTER)

        desc_label = Gtk.Label(
            label="This installer will help you set up your software environment.\n"
                  "Select the applications you want to install and we'll handle the rest."
        )
        desc_label.set_name("page-desc")
        desc_label.set_halign(Gtk.Align.CENTER)
        desc_label.set_justify(Gtk.Justification.CENTER)
        desc_label.set_margin_top(12)
        desc_label.set_line_wrap(True)

        info_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        info_box.set_margin_top(32)
        for line in ["✓  Supports .deb packages, Flatpak, and portable apps",
                     "✓  Step-by-step progress tracking",
                     "✓  Installation summary with error reporting"]:
            lbl = Gtk.Label(label=line)
            lbl.set_name("pkg-name")
            lbl.set_halign(Gtk.Align.CENTER)
            info_box.pack_start(lbl, False, False, 0)

        box.pack_start(icon, False, False, 0)
        box.pack_start(title, False, False, 0)
        box.pack_start(desc_label, False, False, 0)
        box.pack_start(info_box, False, False, 0)
        return box

    def _build_select(self):
        outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        outer.set_name("content")

        title = Gtk.Label(label="Select Software")
        title.set_name("page-title")
        title.set_halign(Gtk.Align.START)
        title.set_margin_start(32)
        title.set_margin_top(24)

        desc = Gtk.Label(label="Choose the applications to install. Recommended items are pre-selected.")
        desc.set_name("page-desc")
        desc.set_halign(Gtk.Align.START)
        desc.set_margin_start(32)

        # Select All / None buttons
        btn_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        btn_row.set_margin_start(32)
        btn_row.set_margin_bottom(8)
        btn_all = Gtk.Button(label="Select All")
        btn_all.set_name("btn-back")
        btn_all.connect("clicked", lambda _: self._select_all(True))
        btn_none = Gtk.Button(label="Select None")
        btn_none.set_name("btn-back")
        btn_none.connect("clicked", lambda _: self._select_all(False))
        btn_row.pack_start(btn_all, False, False, 0)
        btn_row.pack_start(btn_none, False, False, 0)

        # Scrollable package list
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scroll.set_margin_start(24)
        scroll.set_margin_end(24)
        scroll.set_margin_bottom(12)

        pkg_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        pkg_box.set_margin_start(8)
        pkg_box.set_margin_end(8)

        for cat_name, packages in CATEGORIES:
            cat_lbl = Gtk.Label(label=cat_name)
            cat_lbl.set_name("category-label")
            cat_lbl.set_halign(Gtk.Align.START)
            cat_lbl.set_margin_top(16)
            pkg_box.pack_start(cat_lbl, False, False, 0)

            for pkg_id, pkg_name, pkg_type in packages:
                row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
                row.set_name("pkg-row")

                cb = Gtk.CheckButton()
                cb.set_margin_start(4)
                cb.set_margin_end(8)
                cb.set_active(False)
                cb.connect("toggled", self._on_toggle, pkg_id)
                self.checkboxes[pkg_id] = cb

                name_lbl = Gtk.Label(label=pkg_name)
                name_lbl.set_name("pkg-name")
                name_lbl.set_halign(Gtk.Align.START)

                type_lbl = Gtk.Label(label=f"  [{pkg_type}]")
                type_lbl.set_name("pkg-type")
                type_lbl.set_halign(Gtk.Align.START)

                row.pack_start(cb, False, False, 0)
                row.pack_start(name_lbl, False, False, 0)
                row.pack_start(type_lbl, False, False, 0)
                pkg_box.pack_start(row, False, False, 2)

        scroll.add(pkg_box)
        outer.pack_start(title, False, False, 0)
        outer.pack_start(desc, False, False, 4)
        outer.pack_start(btn_row, False, False, 0)
        outer.pack_start(scroll, True, True, 0)
        return outer

    def _build_confirm(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        box.set_name("content")
        box.set_margin_start(32)
        box.set_margin_end(32)
        box.set_margin_top(24)

        title = Gtk.Label(label="Confirm Installation")
        title.set_name("page-title")
        title.set_halign(Gtk.Align.START)

        desc = Gtk.Label(label="The following software will be installed. Click Install to begin.")
        desc.set_name("page-desc")
        desc.set_halign(Gtk.Align.START)
        desc.set_margin_top(4)
        desc.set_margin_bottom(16)

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)

        self.confirm_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
        scroll.add(self.confirm_box)

        box.pack_start(title, False, False, 0)
        box.pack_start(desc, False, False, 0)
        box.pack_start(scroll, True, True, 0)
        return box

    def _build_installing(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_name("content")
        box.set_margin_start(40)
        box.set_margin_end(40)
        box.set_margin_top(40)

        title = Gtk.Label(label="Installing Software")
        title.set_name("page-title")
        title.set_halign(Gtk.Align.START)

        self.status_label = Gtk.Label(label="Preparing...")
        self.status_label.set_name("status-label")
        self.status_label.set_halign(Gtk.Align.START)
        self.status_label.set_margin_top(20)

        self.step_label = Gtk.Label(label="")
        self.step_label.set_name("step-label")
        self.step_label.set_halign(Gtk.Align.START)

        self.progress = Gtk.ProgressBar()
        self.progress.set_name("progress-bar")
        self.progress.set_show_text(True)
        self.progress.set_fraction(0)

        # Log output
        log_scroll = Gtk.ScrolledWindow()
        log_scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        log_scroll.set_min_content_height(240)

        self.log_buffer = Gtk.TextBuffer()
        self.log_view = Gtk.TextView(buffer=self.log_buffer)
        self.log_view.set_name("log-view")
        self.log_view.set_editable(False)
        self.log_view.set_cursor_visible(False)
        self.log_view.set_wrap_mode(Gtk.WrapMode.WORD_CHAR)
        log_scroll.add(self.log_view)

        box.pack_start(title, False, False, 0)
        box.pack_start(self.status_label, False, False, 0)
        box.pack_start(self.step_label, False, False, 0)
        box.pack_start(self.progress, False, False, 0)
        box.pack_start(log_scroll, True, True, 0)
        return box

    def _build_finish(self):
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=16)
        box.set_name("content")
        box.set_margin_start(60)
        box.set_margin_end(60)
        box.set_margin_top(60)

        icon = Gtk.Label(label="✓")
        icon.set_name("summary-success")
        ctx = icon.get_pango_context()
        desc = ctx.get_font_description()
        desc.set_size(56 * Pango.SCALE)
        icon.override_font(desc)
        icon.set_halign(Gtk.Align.CENTER)

        self.finish_title = Gtk.Label(label="Installation Complete!")
        self.finish_title.set_name("summary-success")
        self.finish_title.set_halign(Gtk.Align.CENTER)

        self.finish_desc = Gtk.Label(label="")
        self.finish_desc.set_name("page-desc")
        self.finish_desc.set_halign(Gtk.Align.CENTER)
        self.finish_desc.set_justify(Gtk.Justification.CENTER)
        self.finish_desc.set_line_wrap(True)

        self.error_list = Gtk.Label(label="")
        self.error_list.set_name("summary-fail")
        self.error_list.set_halign(Gtk.Align.CENTER)
        self.error_list.set_justify(Gtk.Justification.CENTER)
        self.error_list.set_line_wrap(True)

        box.pack_start(icon, False, False, 0)
        box.pack_start(self.finish_title, False, False, 0)
        box.pack_start(self.finish_desc, False, False, 0)
        box.pack_start(self.error_list, False, False, 0)
        return box

    # ── Navigation ───────────────────────────────────────────────────────────
    def _show_page(self, idx):
        pages = ["welcome", "select", "confirm", "installing", "finish"]
        self.stack.set_visible_child_name(pages[idx])
        self.current_page = idx

        self.btn_back.set_sensitive(idx > 0 and idx < 3)
        self.btn_next.set_sensitive(True)

        if idx == 0:
            self.btn_back.set_visible(False)
            self.btn_next.set_label("Get Started →")
        elif idx == 1:
            self.btn_back.set_visible(True)
            self.btn_next.set_label("Next →")
        elif idx == 2:
            self.btn_back.set_visible(True)
            self.btn_next.set_label("Install →")
            self._refresh_confirm()
        elif idx == 3:
            self.btn_back.set_visible(False)
            self.btn_next.set_sensitive(False)
            self.btn_next.set_label("Installing...")
            self._start_installation()
        elif idx == 4:
            self.btn_back.set_visible(False)
            self.btn_next.set_label("Close")

        self._update_sidebar()

    def _on_next(self, _):
        if self.current_page == 4:
            Gtk.main_quit()
            return
        if self.current_page == 1 and not self.selected:
            self._show_error("No software selected", "Please select at least one program to install.")
            return
        self._show_page(self.current_page + 1)

    def _on_back(self, _):
        if self.current_page > 0:
            self._show_page(self.current_page - 1)

    def _update_sidebar(self):
        for i, lbl in enumerate(self.sidebar_labels):
            if i < self.current_page:
                lbl.set_name("sidebar-item-done")
                lbl.set_text(f"✓  {SIDEBAR_STEPS[i]}")
            elif i == self.current_page:
                lbl.set_name("sidebar-item-active")
                lbl.set_text(SIDEBAR_STEPS[i])
            else:
                lbl.set_name("sidebar-item")
                lbl.set_text(SIDEBAR_STEPS[i])

    # ── Helpers ───────────────────────────────────────────────────────────────
    def _on_toggle(self, cb, pkg_id):
        if cb.get_active():
            self.selected.add(pkg_id)
        else:
            self.selected.discard(pkg_id)

    def _select_all(self, state):
        for pkg_id, cb in self.checkboxes.items():
            cb.set_active(state)

    def _refresh_confirm(self):
        for child in self.confirm_box.get_children():
            self.confirm_box.remove(child)

        sorted_sel = sorted(self.selected)
        for pkg_id in sorted_sel:
            info = INSTALL_STEPS.get(pkg_id)
            if not info:
                continue
            row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
            row.set_name("pkg-row")
            icon = Gtk.Label(label="📦")
            name = Gtk.Label(label=info["name"])
            name.set_name("pkg-name")
            name.set_halign(Gtk.Align.START)
            row.pack_start(icon, False, False, 4)
            row.pack_start(name, False, False, 0)
            self.confirm_box.pack_start(row, False, False, 2)

        self.confirm_box.show_all()

    def _show_error(self, title, msg):
        dlg = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.WARNING,
            buttons=Gtk.ButtonsType.OK,
            text=title
        )
        dlg.format_secondary_text(msg)
        dlg.run()
        dlg.destroy()

    def _log(self, text):
        def _append():
            end = self.log_buffer.get_end_iter()
            self.log_buffer.insert(end, text + "\n")
            adj = self.log_view.get_vadjustment()
            adj.set_value(adj.get_upper() - adj.get_page_size())
        GLib.idle_add(_append)

    def _set_status(self, status, step=""):
        GLib.idle_add(self.status_label.set_text, status)
        GLib.idle_add(self.step_label.set_text, step)

    def _set_progress(self, fraction, text=""):
        GLib.idle_add(self.progress.set_fraction, fraction)
        GLib.idle_add(self.progress.set_text, text)

    # ── Installation ─────────────────────────────────────────────────────────
    def _start_installation(self):
        thread = threading.Thread(target=self._run_installation, daemon=True)
        thread.start()

    def _run_installation(self):
        sorted_sel = sorted(self.selected)
        total = len(sorted_sel)
        self.errors = []

        for idx, pkg_id in enumerate(sorted_sel):
            info = INSTALL_STEPS.get(pkg_id)
            if not info:
                self.errors.append(f"Unknown package ID: {pkg_id}")
                continue

            pkg_name = info["name"]
            steps = info["steps"]
            n_steps = len(steps)
            base = idx / total
            slice_ = 1 / total

            self._set_status(
                f"[{idx+1}/{total}]  {pkg_name}",
                f"0 / {n_steps} steps complete"
            )
            self._log(f"\n{'─'*50}")
            self._log(f"  Installing: {pkg_name}")
            self._log(f"{'─'*50}")

            # If package has a monolithic script, run it
            if "script" in info and all(cmd is None for _, cmd in steps):
                script = info["script"]
                for step_idx, (step_name, _) in enumerate(steps):
                    pct = base + (step_idx / n_steps) * slice_
                    self._set_progress(pct, f"{int(pct*100)}%  —  {pkg_name}: {step_name}")
                    self._set_status(f"[{idx+1}/{total}]  {pkg_name}", f"Step {step_idx+1}/{n_steps}: {step_name}")
                    self._log(f"  → {step_name}...")

                # Run full script
                pct = base + slice_ * 0.9
                self._set_progress(pct, f"{int(pct*100)}%")
                ok = self._run_cmd(script, shell=True)
                if not ok:
                    self.errors.append(pkg_name)
                    self._log(f"  ✗ Failed: {pkg_name}")
            else:
                # Run step by step
                success = True
                for step_idx, (step_name, cmd) in enumerate(steps):
                    pct = base + (step_idx / n_steps) * slice_
                    self._set_progress(pct, f"{int(pct*100)}%  —  {pkg_name}: {step_name}")
                    self._set_status(f"[{idx+1}/{total}]  {pkg_name}", f"Step {step_idx+1}/{n_steps}: {step_name}")
                    self._log(f"  → {step_name}...")
                    if cmd:
                        ok = self._run_cmd(cmd, shell=True)
                        if not ok:
                            self.errors.append(pkg_name)
                            self._log(f"  ✗ Failed at: {step_name}")
                            success = False
                            break

            self._log(f"  ✓ Done: {pkg_name}" if pkg_name not in [e for e in self.errors] else f"  ✗ Error: {pkg_name}")

        # Done
        GLib.idle_add(self._installation_done)

    def _run_cmd(self, cmd, shell=False):
        try:
            result = subprocess.run(
                cmd,
                shell=shell,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True
            )
            for line in result.stdout.splitlines():
                if line.strip():
                    self._log(f"    {line}")
            return result.returncode == 0
        except Exception as e:
            self._log(f"    ERROR: {e}")
            return False

    def _installation_done(self):
        self._set_progress(1.0, "100%  —  Complete!")
        total = len(self.selected)
        failed = len(self.errors)
        success = total - failed

        if failed == 0:
            self.finish_title.set_text("Installation Complete!")
            self.finish_title.set_name("summary-success")
            self.finish_desc.set_text(
                f"All {total} program(s) were installed successfully.\n"
                "You may need to restart your session for some changes to take effect."
            )
            self.error_list.set_text("")
        else:
            self.finish_title.set_text("Installation Finished with Errors")
            self.finish_title.set_name("summary-fail")
            self.finish_desc.set_text(f"{success} succeeded  •  {failed} failed")
            self.error_list.set_text("Failed:\n" + "\n".join(f"  • {e}" for e in self.errors))

        self.btn_next.set_sensitive(True)
        self.btn_next.set_label("Close")
        self._show_page(4)


def check_dependencies():
    try:
        import gi
        gi.require_version("Gtk", "3.0")
        from gi.repository import Gtk
    except Exception:
        print("Missing dependency: python3-gi")
        print("Install with: sudo apt install python3-gi gir1.2-gtk-3.0")
        sys.exit(1)


if __name__ == "__main__":
    check_dependencies()
    win = InstallerWindow()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()