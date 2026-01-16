#!/bin/bash
# Auto-move Downloads to iCloud Quick-Capture
# Run manually or schedule with launchd/cron

DOWNLOADS="$HOME/Downloads"
QUICK_CAPTURE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/📥 INBOX/Quick-Capture"

# Create destination if it doesn't exist
mkdir -p "$QUICK_CAPTURE"

# Count files before
count=$(find "$DOWNLOADS" -maxdepth 1 -type f | wc -l | tr -d ' ')

if [ "$count" -eq 0 ]; then
    echo "📭 Downloads is empty"
    exit 0
fi

# Move all files (not folders) from Downloads to Quick-Capture
find "$DOWNLOADS" -maxdepth 1 -type f -exec mv {} "$QUICK_CAPTURE/" \;

echo "📥 Moved $count file(s) to Quick-Capture"
