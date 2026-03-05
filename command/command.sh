#!/bin/bash

# ============================================================
# SatellaOS - Wrapper Commands Restore Script
# ============================================================

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Helper Functions ---
info()    { echo -e "${CYAN}[*]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1" >&2; }

# --- Source Directory ---
# Use the HOME directory of the user who ran the script (even with sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
SRC="$REAL_HOME/satellaos-installer"

# --- Source Directory Check ---
if [[ ! -d "$SRC" ]]; then
    error "Source directory not found: $SRC"
    exit 1
fi

# --- sudo Check ---
if [[ $EUID -ne 0 ]]; then
    warning "This script requires sudo privileges. Restarting..."
    exec sudo bash "$0" "$@"
fi

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  SatellaOS Command Restore${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# --- Copy Function ---
install_file() {
    local src="$1"
    local dst="$2"
    local label="$3"

    if [[ ! -f "$src" ]]; then
        error "$label source file not found: $src"
        return 1
    fi

    cp "$src" "$dst"
    chmod +x "$dst"
    success "$label → $dst"
}

# --- Restore Files ---
info "Restoring commands..."
echo ""

install_file \
    "$SRC/command/apt-nir/local/bin/apt-nir" \
    "/usr/local/bin/apt-nir" \
    "apt-nir"

install_file \
    "$SRC/command/satellaos-toolbox/satellaos-toolbox" \
    "/usr/local/bin/satellaos-toolbox" \
    "satellaos-toolbox"

# --- Bash Completion ---
info "Installing bash completion..."
COMPLETION_SRC="$SRC/command/apt-nir/etc/bash_completion.d/apt-nir"
COMPLETION_DST="/etc/bash_completion.d/apt-nir"

if [[ -f "$COMPLETION_SRC" ]]; then
    cp "$COMPLETION_SRC" "$COMPLETION_DST"
    success "Bash completion → $COMPLETION_DST"
else
    warning "Bash completion file not found, skipping."
fi

# --- Done ---
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Restore completed successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
warning "Restart your terminal for bash completion to take effect"
echo -e "  or run: ${CYAN}source /etc/bash_completion${NC}"
echo ""