#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 🕸️ STALE FILE DETECTOR — Find forgotten items
# ═══════════════════════════════════════════════════════════════════════════
# Scans INBOX for items that have been sitting too long and need attention.
# Perfect for your Sunday sweep ritual.

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
INBOX="$ICLOUD/📥 INBOX"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  🕸️ STALE FILE DETECTOR"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ─────────────────────────────────────────────────────────────────
# Critical: Items over 2 weeks old (need immediate action)
# ─────────────────────────────────────────────────────────────────

echo "🚨 CRITICAL — Over 2 weeks in INBOX (archive these!):"
echo "─────────────────────────────────────────────────────────────────"

critical=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null)
if [ -n "$critical" ]; then
    echo "$critical" | while read -r file; do
        if [ -n "$file" ]; then
            age=$(( ( $(date +%s) - $(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null) ) / 86400 ))
            echo "  ⚠️  $(basename "$file") — $age days old"
        fi
    done
    critical_count=$(echo "$critical" | grep -c .)
    echo ""
    echo "  📦 Suggested: Move these to 📦 DEEP ARCHIVE/$(date +%Y)/Unsorted/"
else
    echo "  ✅ Nothing critical!"
fi

echo ""

# ─────────────────────────────────────────────────────────────────
# Warning: Items 1-2 weeks old (review soon)
# ─────────────────────────────────────────────────────────────────

echo "⚠️  WARNING — 1-2 weeks old (sort this week):"
echo "─────────────────────────────────────────────────────────────────"

warning=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" -mtime +7 -mtime -14 2>/dev/null)
if [ -n "$warning" ]; then
    echo "$warning" | while read -r file; do
        if [ -n "$file" ]; then
            age=$(( ( $(date +%s) - $(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null) ) / 86400 ))
            echo "  🟡 $(basename "$file") — $age days old"
        fi
    done
else
    echo "  ✅ Nothing in warning zone!"
fi

echo ""

# ─────────────────────────────────────────────────────────────────
# Fresh: Items under 1 week (healthy)
# ─────────────────────────────────────────────────────────────────

echo "✅ FRESH — Under 1 week (you're on top of it):"
echo "─────────────────────────────────────────────────────────────────"

fresh=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" -mtime -7 2>/dev/null)
if [ -n "$fresh" ]; then
    fresh_count=$(echo "$fresh" | grep -c .)
    echo "  $fresh_count items in healthy rotation"
else
    echo "  📭 INBOX is empty — amazing!"
fi

echo ""

# ─────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────

total=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" 2>/dev/null | wc -l | tr -d ' ')
critical_count=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" -mtime +14 2>/dev/null | wc -l | tr -d ' ')
warning_count=$(find "$INBOX" -type f ! -name ".*" ! -name "_*" -mtime +7 -mtime -14 2>/dev/null | wc -l | tr -d ' ')

echo "═══════════════════════════════════════════════════════════════"
echo "  📊 INBOX HEALTH SCORE"
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ "$critical_count" -eq 0 ] && [ "$warning_count" -eq 0 ]; then
    echo "  🏆 EXCELLENT! Your inbox is healthy."
    echo "     No stale items detected. Keep it up!"
elif [ "$critical_count" -eq 0 ]; then
    echo "  👍 GOOD! No critical items."
    echo "     $warning_count items approaching 2-week limit."
else
    echo "  ⚠️  NEEDS ATTENTION"
    echo "     $critical_count items overdue for archiving"
    echo "     $warning_count items need sorting soon"
fi

echo ""
echo "  Total INBOX items: $total"
echo ""

# ─────────────────────────────────────────────────────────────────
# Quick Actions
# ─────────────────────────────────────────────────────────────────

if [ "$critical_count" -gt 0 ]; then
    echo "─────────────────────────────────────────────────────────────────"
    echo "  🚀 QUICK ACTION: Archive all critical items?"
    echo "     Run this command:"
    echo ""
    echo "     mkdir -p \"$ICLOUD/📦 DEEP ARCHIVE/$(date +%Y)/Unsorted-$(date +%m)\" && \\"
    echo "     find \"$INBOX\" -type f -mtime +14 -exec mv {} \"$ICLOUD/📦 DEEP ARCHIVE/$(date +%Y)/Unsorted-$(date +%m)/\" \\;"
    echo ""
fi
