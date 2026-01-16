#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 🎮 GLOSS COMMAND CENTER — Gamified Dashboard
# ═══════════════════════════════════════════════════════════════════════════
# Your daily briefing. Run this to see what's happening across all zones
# and what past-you was working on.

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
NOW=$(date "+%Y-%m-%d %H:%M")
DAY=$(date "+%A")
HOUR=$(date "+%H")

# ═══════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════

count_files() {
    find "$1" -type f ! -name ".*" ! -name "_*" 2>/dev/null | wc -l | tr -d ' '
}

count_recent() {
    find "$1" -type f ! -name ".*" ! -name "_*" -mtime -"$2" 2>/dev/null | wc -l | tr -d ' '
}

progress_bar() {
    local current=$1
    local max=$2
    local width=20
    local filled=$((current * width / max))
    local empty=$((width - filled))

    printf "["
    for ((i=0; i<filled; i++)); do printf "█"; done
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "]"
}

# ═══════════════════════════════════════════════════════════════
# Gather Stats
# ═══════════════════════════════════════════════════════════════

INBOX_TOTAL=$(count_files "$ICLOUD/📥 INBOX")
INBOX_STALE=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null | wc -l | tr -d ' ')
ACTIVE_TOTAL=$(count_files "$ICLOUD/🔥 ACTIVE")
ACTIVE_WEEK=$(count_recent "$ICLOUD/🔥 ACTIVE" 7)
MEDIA_READY=$(count_files "$ICLOUD/📸 MEDIA VAULT/Ready-To-Post")
REFERENCE_TOTAL=$(count_files "$ICLOUD/🏛️ REFERENCE")
STRATEGIC_TOTAL=$(count_files "$ICLOUD/🧠 STRATEGIC THINKING")

# Calculate health score (0-100)
SCORE=100
[ "$INBOX_STALE" -gt 0 ] && SCORE=$((SCORE - INBOX_STALE * 5))
[ "$INBOX_TOTAL" -gt 30 ] && SCORE=$((SCORE - 10))
[ "$ACTIVE_WEEK" -lt 5 ] && SCORE=$((SCORE - 10))
[ "$SCORE" -lt 0 ] && SCORE=0

# ═══════════════════════════════════════════════════════════════
# Display Dashboard
# ═══════════════════════════════════════════════════════════════

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🎮 GLOSS COMMAND CENTER                                ║"
echo "╠═══════════════════════════════════════════════════════════════════════════╣"
echo "║  $DAY, $NOW                                                    ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────────
# Health Score
# ─────────────────────────────────────────────────────────────────

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
if [ "$SCORE" -ge 80 ]; then
    echo "│  🏆 SYSTEM HEALTH: $SCORE/100  — EXCELLENT                                    │"
elif [ "$SCORE" -ge 60 ]; then
    echo "│  👍 SYSTEM HEALTH: $SCORE/100  — GOOD                                         │"
elif [ "$SCORE" -ge 40 ]; then
    echo "│  ⚠️  SYSTEM HEALTH: $SCORE/100  — NEEDS ATTENTION                             │"
else
    echo "│  🚨 SYSTEM HEALTH: $SCORE/100  — CRITICAL                                     │"
fi
echo "│  $(progress_bar $SCORE 100)                                                   │"
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ─────────────────────────────────────────────────────────────────
# Zone Status
# ─────────────────────────────────────────────────────────────────

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  📊 ZONE STATUS                                                             │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"
printf "│  📥 INBOX          │ %3d items │ " "$INBOX_TOTAL"
[ "$INBOX_STALE" -gt 0 ] && printf "⚠️  %d stale" "$INBOX_STALE" || printf "✅ Healthy   "
echo "                        │"

printf "│  🔥 ACTIVE         │ %3d items │ " "$ACTIVE_TOTAL"
[ "$ACTIVE_WEEK" -gt 0 ] && printf "🔥 %d touched this week" "$ACTIVE_WEEK" || printf "💤 Quiet week       "
echo "              │"

printf "│  📸 MEDIA VAULT    │ %3d ready │ " "$MEDIA_READY"
[ "$MEDIA_READY" -gt 0 ] && printf "📤 Content queued!   " || printf "📭 Pipeline empty    "
echo "              │"

printf "│  🏛️  REFERENCE      │ %3d docs  │ " "$REFERENCE_TOTAL"
echo "📚 Knowledge base                      │"

printf "│  🧠 STRATEGIC      │ %3d docs  │ " "$STRATEGIC_TOTAL"
echo "🎯 Big picture plans                   │"
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ─────────────────────────────────────────────────────────────────
# Today's Missions
# ─────────────────────────────────────────────────────────────────

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  🎯 TODAY'S MISSIONS                                                        │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"

mission_count=0

if [ "$INBOX_STALE" -gt 0 ]; then
    echo "│  [ ] 🚨 Archive $INBOX_STALE stale items from INBOX (+20 XP)                       │"
    mission_count=$((mission_count + 1))
fi

if [ "$INBOX_TOTAL" -gt 15 ]; then
    echo "│  [ ] 📥 Clear INBOX below 15 items (+15 XP)                                 │"
    mission_count=$((mission_count + 1))
fi

if [ "$MEDIA_READY" -gt 0 ]; then
    echo "│  [ ] 📤 Post content from Ready-To-Post queue (+10 XP)                     │"
    mission_count=$((mission_count + 1))
fi

if [ "$DAY" = "Sunday" ]; then
    echo "│  [ ] 🧹 Complete weekly sweep ritual (+25 XP)                              │"
    mission_count=$((mission_count + 1))
fi

if [ "$mission_count" -eq 0 ]; then
    echo "│  ✅ All clear! No urgent missions. Enjoy your day!                         │"
fi

echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ─────────────────────────────────────────────────────────────────
# Recent Activity (What Past-You Was Doing)
# ─────────────────────────────────────────────────────────────────

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
echo "│  🕐 WHAT PAST-YOU WAS WORKING ON                                            │"
echo "├─────────────────────────────────────────────────────────────────────────────┤"

# Get 5 most recently modified files
recent=$(find "$ICLOUD/🔥 ACTIVE" "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime -3 2>/dev/null | head -5)
if [ -n "$recent" ]; then
    echo "$recent" | while read -r file; do
        if [ -n "$file" ]; then
            name=$(basename "$file")
            # Truncate long names
            if [ ${#name} -gt 50 ]; then
                name="${name:0:47}..."
            fi
            zone="???"
            case "$file" in
                *"📥 INBOX"*) zone="INBOX" ;;
                *"🔥 ACTIVE"*) zone="ACTIVE" ;;
            esac
            printf "│  • %-50s [%s]\n" "$name" "$zone"
        fi
    done
else
    echo "│  No recent activity in the last 3 days                                     │"
fi
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ─────────────────────────────────────────────────────────────────
# Greeting based on time
# ─────────────────────────────────────────────────────────────────

echo "┌─────────────────────────────────────────────────────────────────────────────┐"
if [ "$HOUR" -lt 12 ]; then
    echo "│  ☀️  Good morning! Ready to crush it today?                                 │"
elif [ "$HOUR" -lt 17 ]; then
    echo "│  🌤️  Good afternoon! Stay focused, you're doing great.                     │"
else
    echo "│  🌙 Good evening! Time to wrap up and plan tomorrow.                       │"
fi
echo "└─────────────────────────────────────────────────────────────────────────────┘"
echo ""

# ─────────────────────────────────────────────────────────────────
# Quick Commands
# ─────────────────────────────────────────────────────────────────

echo "💡 Quick commands:"
echo "   ./scripts/update-context.sh    — Refresh all context journals"
echo "   ./scripts/stale-detector.sh    — Find forgotten items"
echo "   ./scripts/watch-folders.sh &   — Start auto-logging"
echo "   open \"$ICLOUD/📥 INBOX\"        — Jump to INBOX"
echo ""
