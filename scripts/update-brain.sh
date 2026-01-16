#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 🧠 UPDATE BRAIN — Sync the central nervous system
# ═══════════════════════════════════════════════════════════════════════════
# Updates _GLOSS_BRAIN.md with real data from all zones.
# Also updates all _CONTEXT.md files and generates connections.

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
BRAIN="$ICLOUD/_GLOSS_BRAIN.md"
NOW=$(date "+%Y-%m-%d %H:%M")
TODAY=$(date "+%Y-%m-%d")

echo ""
echo "🧠 UPDATING GLOSS BRAIN"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════
# Gather Stats
# ═══════════════════════════════════════════════════════════════

count_files() {
    find "$1" -type f ! -name ".*" ! -name "_*" 2>/dev/null | wc -l | tr -d ' '
}

INBOX_TOTAL=$(count_files "$ICLOUD/📥 INBOX")
INBOX_STALE=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null | wc -l | tr -d ' ')
ACTIVE_TOTAL=$(count_files "$ICLOUD/🔥 ACTIVE")
ACTIVE_WEEK=$(find "$ICLOUD/🔥 ACTIVE" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
MEDIA_READY=$(count_files "$ICLOUD/📸 MEDIA VAULT/Ready-To-Post")
REFERENCE_TOTAL=$(count_files "$ICLOUD/🏛️ REFERENCE")

# Calculate health score
SCORE=100
[ "$INBOX_STALE" -gt 0 ] && SCORE=$((SCORE - INBOX_STALE * 5))
[ "$INBOX_TOTAL" -gt 30 ] && SCORE=$((SCORE - 10))
[ "$ACTIVE_WEEK" -lt 3 ] && SCORE=$((SCORE - 10))
[ "$SCORE" -lt 0 ] && SCORE=0

# Determine status emoji
if [ "$SCORE" -ge 80 ]; then STATUS="🟢 Excellent"
elif [ "$SCORE" -ge 60 ]; then STATUS="🟡 Good"
elif [ "$SCORE" -ge 40 ]; then STATUS="🟠 Needs attention"
else STATUS="🔴 Critical"; fi

INBOX_STATUS="✅"
[ "$INBOX_TOTAL" -gt 20 ] && INBOX_STATUS="⚠️"
[ "$INBOX_STALE" -gt 0 ] && INBOX_STATUS="🚨 $INBOX_STALE stale"

ACTIVE_STATUS="✅ $ACTIVE_WEEK this week"
[ "$ACTIVE_WEEK" -eq 0 ] && ACTIVE_STATUS="💤 Quiet"

CONTENT_STATUS="📭 Empty"
[ "$MEDIA_READY" -gt 0 ] && CONTENT_STATUS="📤 $MEDIA_READY ready"

echo "  📊 Stats gathered"

# ═══════════════════════════════════════════════════════════════
# Update Brain File
# ═══════════════════════════════════════════════════════════════

if [ -f "$BRAIN" ]; then
    # Update the SYSTEM STATUS section
    # Using a temp file approach for complex sed operations

    # Create updated status block
    STATUS_BLOCK="| Metric | Value | Status |
|--------|-------|--------|
| INBOX items | $INBOX_TOTAL | $INBOX_STATUS |
| Stale items | $INBOX_STALE | $([ "$INBOX_STALE" -eq 0 ] && echo "✅" || echo "🚨 Archive these!") |
| Active files | $ACTIVE_TOTAL | $ACTIVE_STATUS |
| Content ready | $MEDIA_READY | $CONTENT_STATUS |
| Health score | $SCORE/100 | $STATUS |

*Last updated: $NOW*"

    # Update using perl for reliability across platforms
    perl -i -p0e "s/\| Metric \| Value.*?\*Last updated:.*?\*/$(echo "$STATUS_BLOCK" | sed 's/[&/\]/\\&/g' | tr '\n' '\r')/s" "$BRAIN" 2>/dev/null

    echo "  ✓ Updated _GLOSS_BRAIN.md"
else
    echo "  ⚠️  _GLOSS_BRAIN.md not found — run init-brain.sh first"
fi

# ═══════════════════════════════════════════════════════════════
# Update All Context Files
# ═══════════════════════════════════════════════════════════════

echo "  📝 Updating context files..."

# Run the update-context script if it exists
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/update-context.sh" ]; then
    "$SCRIPT_DIR/update-context.sh" > /dev/null 2>&1
    echo "  ✓ All _CONTEXT.md files updated"
fi

# ═══════════════════════════════════════════════════════════════
# Detect Connections & Patterns
# ═══════════════════════════════════════════════════════════════

echo "  🔗 Detecting patterns..."

PATTERNS=""

# Check for related files across zones (same name patterns)
for file in "$ICLOUD/📥 INBOX"/**/* "$ICLOUD/🔥 ACTIVE"/**/*; do
    if [ -f "$file" ]; then
        basename=$(basename "$file" | sed 's/\.[^.]*$//')
        # Look for similar files in other zones
        similar=$(find "$ICLOUD" -type f -name "*$basename*" 2>/dev/null | grep -v "$(dirname "$file")" | head -3)
        if [ -n "$similar" ]; then
            PATTERNS+="Found related: $basename\n"
        fi
    fi
done 2>/dev/null

# Check for date-based patterns
TODAY_FILES=$(find "$ICLOUD" -type f ! -name ".*" ! -name "_*" -name "*$(date +%Y-%m-%d)*" 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODAY_FILES" -gt 0 ]; then
    PATTERNS+="📅 $TODAY_FILES files from today detected\n"
fi

# Check for project keywords
for keyword in "mattegloss" "byjisel" "invoice" "contract"; do
    count=$(find "$ICLOUD/📥 INBOX" "$ICLOUD/🔥 ACTIVE" -type f -iname "*$keyword*" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt 0 ]; then
        PATTERNS+="🏷️  $count files related to '$keyword'\n"
    fi
done

echo "  ✓ Patterns detected"

# ═══════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  🧠 BRAIN SYNC COMPLETE"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  Health Score: $SCORE/100 $STATUS"
echo ""
echo "  📥 INBOX:  $INBOX_TOTAL items ($INBOX_STALE stale)"
echo "  🔥 ACTIVE: $ACTIVE_TOTAL items ($ACTIVE_WEEK touched this week)"
echo "  📤 READY:  $MEDIA_READY posts queued"
echo ""

if [ -n "$PATTERNS" ]; then
    echo "  🔗 Patterns Detected:"
    echo -e "$PATTERNS" | sed 's/^/     /'
    echo ""
fi

echo "  📍 Open _GLOSS_BRAIN.md to see everything"
echo ""
