#!/bin/bash

# ============================================================
#  Thunar Custom Actions (uca.xml) Generator
#  For Debian / XFCE
# ============================================================

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║       Thunar Custom Actions Generator (uca.xml)      ║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""

# ============================================================
# Archive manager selection
# ============================================================

echo -e "${BOLD}Select your archive manager:${RESET}"
echo ""
echo -e "${GREEN}┌──────────────────────────────────────┐${RESET}"
echo -e "${GREEN}│  1)  Engrampa  (XFCE / MATE)         │${RESET}"
echo -e "${GREEN}│  2)  File Roller  (GNOME)            │${RESET}"
echo -e "${GREEN}└──────────────────────────────────────┘${RESET}"
echo ""
echo -ne "${BOLD}Your choice [1/2]: ${RESET}"
read -r arch_choice

case "$arch_choice" in
    1)
        ARCHIVER="engrampa"
        ARCHIVER_LABEL="Engrampa"
        ;;
    2)
        ARCHIVER="file-roller"
        ARCHIVER_LABEL="File Roller"
        ;;
    *)
        echo -e "${RED}Invalid choice. Defaulting to Engrampa.${RESET}"
        ARCHIVER="engrampa"
        ARCHIVER_LABEL="Engrampa"
        ;;
esac

echo ""
echo -e "${YELLOW}✔ Archive manager: ${BOLD}$ARCHIVER_LABEL${RESET}"
echo ""

# ============================================================
# Action selection
# ============================================================

echo -e "${BOLD}Select the actions you want to add.${RESET}"
echo -e "${YELLOW}Separate multiple numbers with spaces or commas.${RESET}"
echo -e "${YELLOW}To select all actions type: ${BOLD}all${RESET}"
echo ""

echo -e "${GREEN}┌─────────────────────────────────────────────────────────────────┐${RESET}"
echo -e "${GREEN}│  #   Action Name                                                │${RESET}"
echo -e "${GREEN}├─────────────────────────────────────────────────────────────────┤${RESET}"
echo -e "${GREEN}│  1)  Open Terminal Here                                         │${RESET}"
echo -e "${GREEN}│  2)  Open as Root                                               │${RESET}"
echo -e "${GREEN}│  3)  Create a Link                                              │${RESET}"
echo -e "${GREEN}│  4)  Verify  (ISO files)                                        │${RESET}"
printf "${GREEN}│  5)  Extract Here             [%-11s]                     │${RESET}\n" "$ARCHIVER_LABEL"
printf "${GREEN}│  6)  Extract to Subfolder     [%-11s]                     │${RESET}\n" "$ARCHIVER_LABEL"
printf "${GREEN}│  7)  Compress                 [%-11s]                     │${RESET}\n" "$ARCHIVER_LABEL"
echo -e "${GREEN}│  8)  Share with LocalSend                                       │${RESET}"
echo -e "${GREEN}└─────────────────────────────────────────────────────────────────┘${RESET}"
echo ""

echo -ne "${BOLD}Your selection: ${RESET}"
read -r input

# Normalize input
input=$(echo "$input" | tr ',' ' ')

# "all" option
if [[ "$input" == "all" ]]; then
    selected=(1 2 3 4 5 6 7 8)
else
    selected=($input)
fi

# Validate selections
valid=()
invalid=()
for num in "${selected[@]}"; do
    if [[ "$num" =~ ^[1-8]$ ]]; then
        valid+=("$num")
    else
        invalid+=("$num")
    fi
done

if [[ ${#invalid[@]} -gt 0 ]]; then
    echo ""
    echo -e "${RED}Invalid selection(s) ignored: ${invalid[*]}${RESET}"
fi

if [[ ${#valid[@]} -eq 0 ]]; then
    echo ""
    echo -e "${RED}No valid selection made. Exiting.${RESET}"
    exit 1
fi

# Remove duplicates
mapfile -t valid < <(printf '%s\n' "${valid[@]}" | sort -un)

# ============================================================
# XML Action Definitions
# ============================================================

action_1='	<action>
		<icon>utilities-terminal</icon>
		<name>Open Terminal Here</name>
		<submenu></submenu>
		<unique-id>1769597937281634-1</unique-id>
		<command>exo-open --working-directory %f --launch TerminalEmulator</command>
		<description>Open terminal in the selected folder</description>
		<range></range>
		<patterns>*</patterns>
		<startup-notify/>
		<directories/>
	</action>'

action_2='	<action>
		<icon>folder-violet</icon>
		<name>Open as Root</name>
		<submenu></submenu>
		<unique-id>1770219086580287-1</unique-id>
		<command>pkexec thunar %F</command>
		<description>Open the folder with administration privileges</description>
		<range></range>
		<patterns>*</patterns>
		<directories/>
	</action>'

action_3='	<action>
		<icon>emblem-symbolic-link</icon>
		<name>Create a Link</name>
		<submenu></submenu>
		<unique-id>1770219212901542-2</unique-id>
		<command>ln -s %f  &apos;Link to %n&apos;</command>
		<description>Create a symbolic link for each selected item</description>
		<range></range>
		<patterns>*</patterns>
		<directories/>
		<other-files/>
	</action>'

action_4='	<action>
		<icon>view-certificate</icon>
		<name>Verify</name>
		<submenu></submenu>
		<unique-id>1770219273064615-3</unique-id>
		<command>mint-iso-verify %f</command>
		<description>Verify the authenticity and integrity of the image</description>
		<range></range>
		<patterns>*.iso;*.ISO</patterns>
		<audio-files/>
		<image-files/>
		<other-files/>
		<video-files/>
	</action>'

action_8='	<action>
		<icon>localsend_app</icon>
		<name>Share with LocalSend</name>
		<submenu></submenu>
		<unique-id>1772531131988710-1</unique-id>
		<command>localsend_app %F || flatpak run org.localsend.localsend_app %F</command>
		<description>Send selected files to local devices via LocalSend</description>
		<range>*</range>
		<patterns>*</patterns>
		<directories/>
		<audio-files/>
		<image-files/>
		<other-files/>
		<text-files/>
		<video-files/>
	</action>'

get_action_5() {
	cat <<EOF
	<action>
		<icon>archive</icon>
		<name>Extract Here</name>
		<submenu></submenu>
		<unique-id>1771847360474275-1</unique-id>
		<command>${ARCHIVER} --extract-here --force %f</command>
		<description>Extracts the archive contents into the current folder.</description>
		<range>*</range>
		<patterns>*.zip;*.tar;*.tar.gz;*.tar.xz;*.tgz;*.rar;*.7z</patterns>
		<other-files/>
	</action>
EOF
}

get_action_6() {
	cat <<EOF
	<action>
		<icon>archive</icon>
		<name>Extract to Subfolder</name>
		<submenu></submenu>
		<unique-id>1771847790175342-2</unique-id>
		<command>bash -c &apos;dir=&quot;\$(dirname &quot;%f&quot;)/\$(basename &quot;%f&quot; | sed &quot;s/\.[^.]*\$//&quot;)&quot;; mkdir -p &quot;\$dir&quot;; ${ARCHIVER} --extract-to=&quot;\$dir&quot; --force &quot;%f&quot;&apos;</command>
		<description>Extracts the archive contents into a new folder named after the archive.</description>
		<range>*</range>
		<patterns>*.zip;*.tar;*.tar.gz;*.tar.xz;*.tgz;*.rar;*.7z</patterns>
		<other-files/>
	</action>
EOF
}

get_action_7() {
	cat <<EOF
	<action>
		<icon>add-files-to-archive</icon>
		<name>Compress</name>
		<submenu></submenu>
		<unique-id>1771923204368861-1</unique-id>
		<command>${ARCHIVER} -d %F</command>
		<description>Compresses the selected files and folders into a new archive.</description>
		<range>*</range>
		<patterns>*</patterns>
		<directories/>
		<audio-files/>
		<image-files/>
		<other-files/>
		<text-files/>
		<video-files/>
	</action>
EOF
}

# ============================================================
# Generate XML
# ============================================================

OUTPUT_DIR="$HOME/.config/Thunar"
OUTPUT_FILE="$OUTPUT_DIR/uca.xml"

SKEL_DIR="/etc/skel/.config/Thunar"
SKEL_FILE="$SKEL_DIR/uca.xml"

mkdir -p "$OUTPUT_DIR"

{
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<actions>'

    for num in "${valid[@]}"; do
        case "$num" in
            5) get_action_5 ;;
            6) get_action_6 ;;
            7) get_action_7 ;;
            *) eval "echo \"\$action_$num\"" ;;
        esac
    done

    echo '</actions>'
} > "$OUTPUT_FILE"

if sudo mkdir -p "$SKEL_DIR" 2>/dev/null && sudo cp "$OUTPUT_FILE" "$SKEL_FILE" 2>/dev/null; then
    SKEL_OK=true
else
    SKEL_OK=false
fi

# ============================================================
# Summary
# ============================================================

echo ""
echo -e "${CYAN}══════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}✔  uca.xml generated successfully!${RESET}"
echo -e "${CYAN}══════════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${BOLD}Actions added:${RESET}"

declare -A action_names
action_names[1]="Open Terminal Here"
action_names[2]="Open as Root"
action_names[3]="Create a Link"
action_names[4]="Verify"
action_names[5]="Extract Here             [$ARCHIVER_LABEL]"
action_names[6]="Extract to Subfolder     [$ARCHIVER_LABEL]"
action_names[7]="Compress                 [$ARCHIVER_LABEL]"
action_names[8]="Share with LocalSend"

for num in "${valid[@]}"; do
    echo -e "  ${GREEN}✔${RESET}  $num) ${action_names[$num]}"
done

echo ""
echo -e "${YELLOW}📄 File location: $OUTPUT_FILE${RESET}"
if $SKEL_OK; then
    echo -e "${YELLOW}📄 File location: $SKEL_FILE${RESET}"
else
    echo -e "${RED}⚠  Could not write to $SKEL_FILE (requires root)${RESET}"
fi
echo ""
echo -e "${BOLD}To restart Thunar:${RESET}"
echo -e "  ${CYAN}thunar -q && thunar &${RESET}"
echo ""