#!/bin/bash

LOCAL="/home/ubuntu/AutoSync/local_folder"
REMOTE="gdrive2024:backup"
LOG="/home/ubuntu/AutoSync/autosync.log"

echo "=== Sync started at $(date) ===" >> "$LOG"

# Sync local → Google Drive
rclone sync "$LOCAL" "$REMOTE" --create-empty-src-dirs >> "$LOG" 2>&1

echo "=== Sync completed at $(date) ===" >> "$LOG"
echo "" >> "$LOG"
