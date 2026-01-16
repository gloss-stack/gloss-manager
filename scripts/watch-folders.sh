#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 👁️ FOLDER WATCHER — Logs every new file automatically
# ═══════════════════════════════════════════════════════════════════════════
# This runs in the background and logs every file that lands in your system.
# Requires: fswatch (install with: brew install fswatch)
#
# Usage:
#   ./watch-folders.sh        # Run in foreground
#   ./watch-folders.sh &      # Run in background
#   ./watch-folders.sh stop   # Stop the watcher

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
LOG_FILE="$ICLOUD/_activity-log.md"
PID_FILE="/tmp/icloud-watcher.pid"

# Check for fswatch
if ! command -v fswatch &> /dev/null; then
    echo "❌ fswatch not found. Install it with:"
    echo "   brew install fswatch"
    exit 1
fi

# Handle stop command
if [ "$1" = "stop" ]; then
    if [ -f "$PID_FILE" ]; then
        kill $(cat "$PID_FILE") 2>/dev/null
        rm "$PID_FILE"
        echo "✅ Folder watcher stopped"
    else
        echo "⚠️ No watcher running"
    fi
    exit 0
fi

# Initialize log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    cat > "$LOG_FILE" << 'EOF'
# 📋 Activity Log — Your Digital Paper Trail

> This file auto-updates every time a file is added, modified, or moved.
> Use this to rebuild context about what past-you was working on.

---

## Recent Activity

EOF
fi

echo "👁️ Folder watcher started"
echo "📝 Logging to: $LOG_FILE"
echo "   Stop with: $0 stop"
echo ""

# Save PID for stopping later
echo $$ > "$PID_FILE"

# Watch for new/modified files
fswatch -0 --event Created --event Renamed \
    "$ICLOUD/📥 INBOX" \
    "$ICLOUD/🔥 ACTIVE" \
    "$ICLOUD/🏛️ REFERENCE" \
    "$ICLOUD/📸 MEDIA VAULT" \
    "$ICLOUD/🧠 STRATEGIC THINKING" \
    "$ICLOUD/📦 DEEP ARCHIVE" \
    2>/dev/null | while IFS= read -r -d '' file; do

    # Skip hidden files and context files
    filename=$(basename "$file")
    if [[ "$filename" == .* ]] || [[ "$filename" == _* ]]; then
        continue
    fi

    # Determine which zone
    zone="Unknown"
    case "$file" in
        *"📥 INBOX"*) zone="📥 INBOX" ;;
        *"🔥 ACTIVE"*) zone="🔥 ACTIVE" ;;
        *"🏛️ REFERENCE"*) zone="🏛️ REFERENCE" ;;
        *"📸 MEDIA VAULT"*) zone="📸 MEDIA VAULT" ;;
        *"🧠 STRATEGIC"*) zone="🧠 STRATEGIC" ;;
        *"📦 DEEP ARCHIVE"*) zone="📦 ARCHIVE" ;;
    esac

    # Get subfolder
    subfolder=$(echo "$file" | sed "s|$ICLOUD/||" | cut -d'/' -f2)

    # Timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M")

    # Log entry
    entry="| $timestamp | $zone | \`$filename\` | $subfolder |"

    # Append to log (at the top of the Recent Activity section)
    # Using a temp file approach for safety
    temp_file=$(mktemp)
    head -n 10 "$LOG_FILE" > "$temp_file"
    echo "$entry" >> "$temp_file"
    tail -n +11 "$LOG_FILE" >> "$temp_file"
    mv "$temp_file" "$LOG_FILE"

    echo "📝 Logged: $filename → $zone"
done
