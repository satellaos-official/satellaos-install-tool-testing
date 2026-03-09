#!/bin/bash
# Debian Drivers & Configurations Setup
# Requires: whiptail, sudo

set -e
set -u

if ! command -v whiptail &>/dev/null; then
    sudo apt install -y whiptail
fi

VERSION="1.0.0"

CHOICES=$(whiptail --title "SatellaOS Driver Setup v$VERSION" \
    --checklist "Select the drivers/configurations you want to install:\n(SPACE to mark, ENTER to confirm, TAB to switch between OK/Cancel)" \
    20 70 7 \
    "1" "AMD Graphics Driver"         OFF \
    "2" "Intel Graphics Driver"       OFF \
    "3" "VMware Graphics Driver"      OFF \
    "4" "VirtualBox Graphics Driver"  OFF \
    "5" "ADB Driver"                  OFF \
    "6" "Bluetooth Modules"           OFF \
    "7" "Touchpad tap-to-click"       OFF \
    3>&1 1>&2 2>&3) || { echo "Cancelled. Exiting."; exit 0; }

# Remove quotes and duplicates
SELECTIONS=$(echo "$CHOICES" | tr -d '"' | tr ' ' '\n' | sort -u)

if [[ -z "$SELECTIONS" ]]; then
    whiptail --title "SatellaOS Driver Setup" --msgbox "No driver selected. Exiting." 8 40
    exit 0
fi

# ── Confirmation screen ──
CONFIRM_LIST=$(echo "$SELECTIONS" | tr '\n' ' ')
whiptail --title "Confirmation" --yesno "The following drivers will be installed/configured:\n\n$CONFIRM_LIST\n\nDo you want to continue?" 15 60
if [ $? -ne 0 ]; then
    echo "Cancelled."
    exit 0
fi

# ──────────────────────────────────────────────
# 1) AMD Graphics Driver
# ──────────────────────────────────────────────
install_1() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y \
        firmware-amd-graphics \
        mesa-vulkan-drivers \
        mesa-va-drivers \
        mesa-vdpau-drivers
}

# ──────────────────────────────────────────────
# 2) Intel Graphics Driver
# ──────────────────────────────────────────────
install_2() {
    sudo apt update
    sudo apt install -y \
        firmware-misc-nonfree \
        intel-media-va-driver \
        i965-va-driver \
        mesa-vulkan-drivers \
        mesa-va-drivers \
        mesa-vdpau-drivers
}

# ──────────────────────────────────────────────
# 3) VMware Graphics Driver
# ──────────────────────────────────────────────
install_3() {
    sudo apt update
    sudo apt install -y open-vm-tools open-vm-tools-desktop
}

# ──────────────────────────────────────────────
# 4) VirtualBox Guest Additions
# ──────────────────────────────────────────────
install_4() {
    local BASE_URL="https://download.virtualbox.org/virtualbox"
    local MOUNT_DIR="/tmp/vbox-guest-additions"
    local TMP_ISO=""

    _vbox_cleanup() {
        mountpoint -q "$MOUNT_DIR" 2>/dev/null && sudo umount "$MOUNT_DIR" 2>/dev/null || true
        [[ -n "$TMP_ISO" && -f "$TMP_ISO" ]] && rm -f "$TMP_ISO" || true
    }
    trap _vbox_cleanup RETURN

    local LATEST_VERSION
    LATEST_VERSION=$(curl -fsSL "${BASE_URL}/LATEST-STABLE.TXT" 2>/dev/null | tr -d '[:space:]') || true
    if [[ -z "$LATEST_VERSION" ]]; then
        LATEST_VERSION=$(
            curl -fsSL "${BASE_URL}/" \
            | grep -oP '(?<=href=")[0-9]+\.[0-9]+\.[0-9]+(?=/)' \
            | sort -V \
            | tail -1
        )
    fi
    [[ -z "$LATEST_VERSION" ]] && return 1

    local ISO_FILENAME="VBoxGuestAdditions_${LATEST_VERSION}.iso"
    TMP_ISO="/tmp/${ISO_FILENAME}"

    curl -fsSL -o "$TMP_ISO" "${BASE_URL}/${LATEST_VERSION}/${ISO_FILENAME}" || return 1

    sudo mkdir -p "$MOUNT_DIR"
    sudo mount -o loop,ro "$TMP_ISO" "$MOUNT_DIR" || return 1

    [[ -f "${MOUNT_DIR}/VBoxLinuxAdditions.run" ]] || return 1
    sudo sh "${MOUNT_DIR}/VBoxLinuxAdditions.run" || return 1
}

# ──────────────────────────────────────────────
# 5) ADB Driver
# ──────────────────────────────────────────────
install_5() {
    sudo apt update
    sudo apt install --no-install-recommends -y \
        adb \
        mtp-tools \
        jmtpfs
}

# ──────────────────────────────────────────────
# 6) Bluetooth Modules
# ──────────────────────────────────────────────
install_6() {
    sudo apt update
    sudo apt install -y bluetooth bluez blueman
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
}

# ──────────────────────────────────────────────
# 7) Touchpad tap-to-click
# ──────────────────────────────────────────────
install_7() {
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null <<EOF
Section "InputClass"
  Identifier "libinput touchpad catchall"
  MatchIsTouchpad "on"
  MatchDevicePath "/dev/input/event*"
  Driver "libinput"
  Option "Tapping" "on"
EndSection
EOF
}

# ──────────────────────────────────────────────
# Run selected items
# ──────────────────────────────────────────────
TOTAL=$(echo "$SELECTIONS" | wc -w)
CURRENT=0

for i in $SELECTIONS; do
    CURRENT=$((CURRENT + 1))
    if declare -f "install_$i" >/dev/null; then
        echo "[$CURRENT/$TOTAL] Installing driver $i..."
        install_$i \
            && echo "[$CURRENT/$TOTAL] Driver $i installed successfully ✓" \
            || echo "[$CURRENT/$TOTAL] ERROR occurred while installing driver $i ✗"
    else
        echo "[$CURRENT/$TOTAL] Invalid selection: $i, skipping."
    fi
done
