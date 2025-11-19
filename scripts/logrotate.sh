#!/bin/bash

LOG_FILE="/home/ubuntu/AutoSync/autosync.log"
LOG_DIR="/home/ubuntu/AutoSync/logs"
MAX_SIZE=5000   # 5000 KB = 5 MB

mkdir -p "$LOG_DIR"

# Check size of autosync.log
FILE_SIZE=$(du -k "$LOG_FILE" | cut -f1)

# If size exceeds limit, rotate
if [ "$FILE_SIZE" -ge "$MAX_SIZE" ]; then
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    
    # Move current log to rotated logs folder
    mv "$LOG_FILE" "$LOG_DIR/autosync_$TIMESTAMP.log"
    
    # Create a new empty log file
    touch "$LOG_FILE"
fi

# Delete logs older than 7 days
find "$LOG_DIR" -type f -mtime +7 -delete
