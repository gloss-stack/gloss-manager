#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 📊 WEEKLY DIGEST — Your week in review
# ═══════════════════════════════════════════════════════════════════════════
# Generates a summary of what you accomplished, what moved, and what's pending.
# Perfect for Sunday evening reflection.

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
NOW=$(date "+%Y-%m-%d %H:%M")
WEEK_START=$(date -v-7d "+%Y-%m-%d" 2>/dev/null || date -d "7 days ago" "+%Y-%m-%d")
WEEK_NUM=$(date "+%V")
YEAR=$(date "+%Y")

# Output file
DIGEST="$ICLOUD/📦 DEEP ARCHIVE/$YEAR/Weekly-Digests"
mkdir -p "$DIGEST"
DIGEST_FILE="$DIGEST/Week-$WEEK_NUM-$YEAR.md"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  📊 GENERATING WEEKLY DIGEST"
echo "  Week $WEEK_NUM of $YEAR"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════
# Gather Weekly Stats
# ═══════════════════════════════════════════════════════════════

# Files created this week
CREATED_INBOX=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
CREATED_ACTIVE=$(find "$ICLOUD/🔥 ACTIVE" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
CREATED_MEDIA=$(find "$ICLOUD/📸 MEDIA VAULT" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
CREATED_REF=$(find "$ICLOUD/🏛️ REFERENCE" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
ARCHIVED=$(find "$ICLOUD/📦 DEEP ARCHIVE" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')

TOTAL_ACTIVITY=$((CREATED_INBOX + CREATED_ACTIVE + CREATED_MEDIA + CREATED_REF + ARCHIVED))

# Most active folder
ACTIVE_MG=$(find "$ICLOUD/🔥 ACTIVE/Mattegloss-ThisWeek" -type f ! -name ".*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
ACTIVE_BJ=$(find "$ICLOUD/🔥 ACTIVE/BYJISEL-ThisWeek" -type f ! -name ".*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
ACTIVE_PERSONAL=$(find "$ICLOUD/🔥 ACTIVE/Personal-ThisWeek" -type f ! -name ".*" -mtime -7 2>/dev/null | wc -l | tr -d ' ')

# Current state
INBOX_NOW=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" 2>/dev/null | wc -l | tr -d ' ')
STALE_NOW=$(find "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null | wc -l | tr -d ' ')

# Files touched this week (unique list)
RECENT_FILES=$(find "$ICLOUD/🔥 ACTIVE" "$ICLOUD/📥 INBOX" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null | while read f; do basename "$f"; done | sort -u | head -15)

# ═══════════════════════════════════════════════════════════════
# Generate Digest
# ═══════════════════════════════════════════════════════════════

cat > "$DIGEST_FILE" << EOF
# 📊 Weekly Digest — Week $WEEK_NUM, $YEAR

> Generated: $NOW
> Period: $WEEK_START to $(date "+%Y-%m-%d")

---

## 🏆 Week at a Glance

| Metric | This Week |
|--------|-----------|
| Total file activity | $TOTAL_ACTIVITY |
| New in INBOX | $CREATED_INBOX |
| Files worked on | $CREATED_ACTIVE |
| Media created | $CREATED_MEDIA |
| Archived | $ARCHIVED |

---

## 🔥 Where You Focused

EOF

# Determine primary focus
if [ "$ACTIVE_MG" -ge "$ACTIVE_BJ" ] && [ "$ACTIVE_MG" -ge "$ACTIVE_PERSONAL" ] && [ "$ACTIVE_MG" -gt 0 ]; then
    echo "**Primary focus this week:** Mattegloss ($ACTIVE_MG files)" >> "$DIGEST_FILE"
elif [ "$ACTIVE_BJ" -ge "$ACTIVE_PERSONAL" ] && [ "$ACTIVE_BJ" -gt 0 ]; then
    echo "**Primary focus this week:** BYJISEL ($ACTIVE_BJ files)" >> "$DIGEST_FILE"
elif [ "$ACTIVE_PERSONAL" -gt 0 ]; then
    echo "**Primary focus this week:** Personal ($ACTIVE_PERSONAL files)" >> "$DIGEST_FILE"
else
    echo "**Light week** — minimal file activity detected" >> "$DIGEST_FILE"
fi

cat >> "$DIGEST_FILE" << EOF

| Project | Files Touched |
|---------|---------------|
| Mattegloss | $ACTIVE_MG |
| BYJISEL | $ACTIVE_BJ |
| Personal | $ACTIVE_PERSONAL |

---

## 📁 Files You Worked On

EOF

if [ -n "$RECENT_FILES" ]; then
    echo "$RECENT_FILES" | while read f; do
        echo "- \`$f\`" >> "$DIGEST_FILE"
    done
else
    echo "*No files detected this week*" >> "$DIGEST_FILE"
fi

cat >> "$DIGEST_FILE" << EOF

---

## 📥 INBOX Health

| Status | Count |
|--------|-------|
| Current items | $INBOX_NOW |
| Stale (2+ weeks) | $STALE_NOW |

EOF

if [ "$STALE_NOW" -gt 0 ]; then
    echo "⚠️ **Action needed:** Archive $STALE_NOW stale items" >> "$DIGEST_FILE"
elif [ "$INBOX_NOW" -lt 10 ]; then
    echo "✅ **Great job!** INBOX is under control" >> "$DIGEST_FILE"
else
    echo "👀 **Heads up:** INBOX has $INBOX_NOW items — consider a sweep" >> "$DIGEST_FILE"
fi

cat >> "$DIGEST_FILE" << EOF

---

## ✍️ Reflection (fill this in!)

### What went well this week?


### What could have gone better?


### What's the #1 priority for next week?


### Any projects to start, pause, or complete?


---

## 🎯 Next Week's Focus

- [ ]
- [ ]
- [ ]

---

*This digest is auto-generated and saved to:*
*📦 DEEP ARCHIVE/$YEAR/Weekly-Digests/Week-$WEEK_NUM-$YEAR.md*
EOF

echo "  ✓ Digest generated"
echo ""

# ═══════════════════════════════════════════════════════════════
# Display Summary
# ═══════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════"
echo "  📊 WEEK $WEEK_NUM SUMMARY"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  📈 Total activity: $TOTAL_ACTIVITY files"
echo ""
echo "  🔥 Focus areas:"
echo "     Mattegloss: $ACTIVE_MG files"
echo "     BYJISEL: $ACTIVE_BJ files"
echo "     Personal: $ACTIVE_PERSONAL files"
echo ""
echo "  📥 INBOX: $INBOX_NOW items ($STALE_NOW stale)"
echo "  📦 Archived: $ARCHIVED files"
echo ""
echo "  📄 Digest saved to:"
echo "     $DIGEST_FILE"
echo ""
echo "  💡 Open the digest and fill in the reflection section!"
echo ""

# Open the digest
if command -v open &> /dev/null; then
    echo "  Opening digest..."
    open "$DIGEST_FILE"
fi
