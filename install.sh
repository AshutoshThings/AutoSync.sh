#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$EUID" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

echo -e "${BLUE}=== AutoSync Installer ===${NC}"

#Depenency Check and Install
if ! command -v rclone &> /dev/null; then
    echo "Error: rclone is not installed."
    echo "to install run : sudo apt install rclone"
    exit 1
fi
if ! command -v inotifywait &> /dev/null; then
    echo -e "${BLUE}[+] Installing inotify-tools...${NC}"
    $SUDO apt-get update && $SUDO apt-get install -y inotify-tools
fi
if ! command -v notify-send &> /dev/null; then
    echo -e "${BLUE}[+] Installing libnotify-bin (for desktop notifications)...${NC}"
    $SUDO apt-get update && $SUDO apt-get install -y libnotify-bin
fi

#Setup Connection
echo -e "${BLUE}[+] Configuring Connection...${NC}"

while true; do
    REMOTES=$(rclone listremotes)

    if [[ -z "$REMOTES" ]]; then
        echo -e "${RED}No remotes found!${NC}"
        echo -e "${BLUE}Launching configuration wizard to create one...${NC}"
        echo "(Tip: Select 'n' for New Remote, pick 'drive', and follow the steps)"
        echo ""
        rclone config
        echo ""
        continue
    fi
    echo "----------------------------------------"
    echo "Available Remotes:"
    echo "$REMOTES"
    echo "----------------------------------------"
    
    read -p "Enter the Remote Name you want to use: " REMOTE_NAME
    REMOTE_NAME=$(echo "$REMOTE_NAME" | xargs)
    if [[ -z "$REMOTE_NAME" ]]; then
        continue
    fi

    if echo "$REMOTES" | grep -q "^${REMOTE_NAME}:$"; then
        echo -e "${GREEN}Selected: $REMOTE_NAME${NC}"
        break
    else
        echo -e "${RED}Remote '$REMOTE_NAME' not found.${NC}"
        read -p "Do you want to create '$REMOTE_NAME' now? [y/N]: " CREATE_CONFIRM
        if [[ "$CREATE_CONFIRM" =~ ^[Yy]$ ]]; then
            rclone config
        fi
    fi
done

echo -e "${BLUE}[+] Setting up Sync Paths...${NC}"
read -p "Which LOCAL folder do you want to sync? (Full path): " LOCAL_DIR
read -p "Which REMOTE folder? (e.g., 'Backups/Work'): " REMOTE_DIR

CONFIG_DIR="$HOME/.config/autosync"
mkdir -p "$CONFIG_DIR"

cat <<EOF > "$CONFIG_DIR/autosync.conf"
# AutoSync Configuration
LOCAL_DIR="$LOCAL_DIR"
REMOTE_NAME="$REMOTE_NAME"
REMOTE_DIR="$REMOTE_DIR"
DELAY=5
EOF
echo -e "${GREEN}Configuration saved to $CONFIG_DIR/autosync.conf${NC}"

echo -e "${BLUE}[+] Installing executables...${NC}"
$SUDO cp bin/autosync /usr/local/bin/autosync
$SUDO chmod +x /usr/local/bin/autosync

if systemctl --user is-active --quiet autosync; then
    systemctl --user stop autosync
fi

if command -v systemctl &> /dev/null && systemctl --user list-units &> /dev/null; then
    mkdir -p "$HOME/.config/systemd/user"
    cp systemd/autosync.service "$HOME/.config/systemd/user/"
    systemctl --user daemon-reload
    systemctl --user enable --now autosync
    
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}AutoSync is running!${NC}"
    echo " - Logs: journalctl --user -u autosync -f"
else
    echo -e "${RED}Systemd not found.${NC}"
    echo "Run manually: autosync &"
fi