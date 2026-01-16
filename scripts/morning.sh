#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# ☀️ MORNING START — Your daily kickoff routine
# ═══════════════════════════════════════════════════════════════════════════
# Run this every morning to:
# 1. Sync your brain file
# 2. See what's on your plate
# 3. Set your top 3 for the day
# 4. Get context on where you left off

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
BRAIN="$ICLOUD/_GLOSS_BRAIN.md"
TIMELINE="$ICLOUD/_TIMELINE.md"
NOW=$(date "+%Y-%m-%d %H:%M")
TODAY=$(date "+%Y-%m-%d")
DAY=$(date "+%A")
HOUR=$(date "+%H")
SCRIPT_DIR="$(dirname "$0")"

clear

# ═══════════════════════════════════════════════════════════════
# Greeting
# ═══════════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
if [ "$HOUR" -lt 12 ]; then
    echo "║  ☀️  Good morning! Let's set up your day.                                  ║"
else
    echo "║  👋 Starting fresh! Let's see where things are.                           ║"
fi
echo "║  $DAY, $(date '+%B %d, %Y')                                              ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

# ═══════════════════════════════════════════════════════════════
# Sync Brain
# ═══════════════════════════════════════════════════════════════

echo "🧠 Syncing your brain..."
"$SCRIPT_DIR/update-brain.sh" > /dev/null 2>&1
echo "   ✓ Brain synced"
echo ""

# ═══════════════════════════════════════════════════════════════
# Quick Stats
# ═══════════════════════════════════════════════════════════════

count_files() {
    find "$1" -type f ! -name ".*" ! -name "_*" 2>/dev/null | wc -l | tr -d ' '
}

INBOX=$(count_files "$ICLOUD/📥 INBOX")
STALE=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null | wc -l | tr -d ' ')
ACTIVE=$(count_files "$ICLOUD/🔥 ACTIVE")
READY=$(count_files "$ICLOUD/📸 MEDIA VAULT/Ready-To-Post")

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  📊 CURRENT STATUS                                                          │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"
printf "│  📥 INBOX: %3d items" "$INBOX"
[ "$STALE" -gt 0 ] && printf " (⚠️ %d stale!)" "$STALE"
echo "                                          │"
printf "│  🔥 ACTIVE: %3d items                                                       │\n" "$ACTIVE"
printf "│  📤 Content ready: %3d                                                      │\n" "$READY"
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ═══════════════════════════════════════════════════════════════
# Yesterday's Context (What were you working on?)
# ═══════════════════════════════════════════════════════════════

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  🕐 WHERE YOU LEFT OFF                                                      │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"

# Get files modified yesterday or last 2 days
YESTERDAY_FILES=$(find "$ICLOUD/🔥 ACTIVE" -type f ! -name ".*" ! -name "_*" -mtime -2 -mtime +0 2>/dev/null | head -5)
if [ -n "$YESTERDAY_FILES" ]; then
    echo "$YESTERDAY_FILES" | while read -r file; do
        name=$(basename "$file")
        [ ${#name} -gt 55 ] && name="${name:0:52}..."
        printf "│  • %-70s │\n" "$name"
    done
else
    echo "│  No activity detected yesterday — fresh start!                            │"
fi
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ═══════════════════════════════════════════════════════════════
# Alerts
# ═══════════════════════════════════════════════════════════════

if [ "$STALE" -gt 0 ] || [ "$INBOX" -gt 25 ]; then
    echo "┌─────────────────────────────────────────────────────────────────────────────┐"
    echo "│  ⚠️  NEEDS ATTENTION                                                        │"
    echo "├─────────────────────────────────────────────────────────────────────────────┤"
    [ "$STALE" -gt 0 ] && echo "│  🚨 $STALE items in INBOX are over 2 weeks old — archive them!              │"
    [ "$INBOX" -gt 25 ] && echo "│  📥 INBOX has $INBOX items — schedule a sweep                              │"
    echo "└─────────────────────────────────────────────────────────────────────────────┘"
    echo ""
fi

# ═══════════════════════════════════════════════════════════════
# Today's Setup
# ═══════════════════════════════════════════════════════════════

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  🎯 SET YOUR TOP 3 FOR TODAY                                                │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"
echo "│                                                                             │"
echo "│  What are the 3 most important things to accomplish today?                  │"
echo "│                                                                             │"
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

echo "  1. What's your #1 priority? (or press Enter to skip)"
read -r TOP1

echo "  2. What's #2?"
read -r TOP2

echo "  3. What's #3?"
read -r TOP3

# ═══════════════════════════════════════════════════════════════
# Log to Timeline & Brain
# ═══════════════════════════════════════════════════════════════

if [ -n "$TOP1" ] || [ -n "$TOP2" ] || [ -n "$TOP3" ]; then
    # Add today's entry to timeline if not exists
    if ! grep -q "## $TODAY" "$TIMELINE" 2>/dev/null; then
        temp_file=$(mktemp)
        head -n 8 "$TIMELINE" > "$temp_file"
        cat >> "$temp_file" << EOF

## $TODAY ($DAY)

### Today's Top 3:
EOF
        [ -n "$TOP1" ] && echo "1. [ ] $TOP1" >> "$temp_file"
        [ -n "$TOP2" ] && echo "2. [ ] $TOP2" >> "$temp_file"
        [ -n "$TOP3" ] && echo "3. [ ] $TOP3" >> "$temp_file"
        cat >> "$temp_file" << EOF

### What I worked on:
-

### What I captured:
-

### Context/Notes:

---
EOF
        tail -n +9 "$TIMELINE" >> "$temp_file"
        mv "$temp_file" "$TIMELINE"
    fi

    echo ""
    echo "  ✓ Logged to _TIMELINE.md"
fi

# ═══════════════════════════════════════════════════════════════
# Final Message
# ═══════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
echo "  ✅ You're all set!"
echo ""
echo "  📍 Your home base: _GLOSS_BRAIN.md"
echo "  📅 Today's log: _TIMELINE.md"
echo ""
echo "  Quick commands:"
echo "    ./scripts/capture.sh     — Save a file with context"
echo "    ./scripts/dashboard.sh   — Full command center"
echo "    open \"$ICLOUD/🔥 ACTIVE\" — Jump to active work"
echo ""
echo "  Have a great day! 🚀"
echo ""
