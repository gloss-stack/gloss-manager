#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 📥 QUICK CAPTURE — Save a file with context
# ═══════════════════════════════════════════════════════════════════════════
# Moves a file to Quick-Capture AND logs why you saved it.
# Usage: ./capture.sh /path/to/file "Why I saved this"
# Or:    ./capture.sh (interactive mode)

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
QUICK_CAPTURE="$ICLOUD/📥 INBOX/Quick-Capture"
TIMELINE="$ICLOUD/_TIMELINE.md"
NOW=$(date "+%Y-%m-%d %H:%M")
TODAY=$(date "+%Y-%m-%d")
DAY=$(date "+%A")

# Ensure Quick-Capture exists
mkdir -p "$QUICK_CAPTURE"

# ═══════════════════════════════════════════════════════════════
# Interactive mode
# ═══════════════════════════════════════════════════════════════

if [ -z "$1" ]; then
    echo ""
    echo "📥 QUICK CAPTURE — Save with context"
    echo "════════════════════════════════════════"
    echo ""
    echo "Drag a file here (or paste path):"
    read -r filepath

    # Clean up path (remove quotes, escape sequences)
    filepath=$(echo "$filepath" | sed "s/^'//" | sed "s/'$//" | sed 's/\\ / /g')

    if [ ! -f "$filepath" ]; then
        echo "❌ File not found: $filepath"
        exit 1
    fi

    echo ""
    echo "Why are you saving this? (brief note):"
    read -r context

    echo ""
    echo "Project this relates to (or press Enter to skip):"
    read -r project
else
    filepath="$1"
    context="${2:-No context provided}"
    project="${3:-}"
fi

# ═══════════════════════════════════════════════════════════════
# Move file
# ═══════════════════════════════════════════════════════════════

filename=$(basename "$filepath")
mv "$filepath" "$QUICK_CAPTURE/"

if [ $? -ne 0 ]; then
    echo "❌ Failed to move file"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# Log to Timeline
# ═══════════════════════════════════════════════════════════════

# Check if today's entry exists
if ! grep -q "## $TODAY" "$TIMELINE" 2>/dev/null; then
    # Add today's header
    temp_file=$(mktemp)
    head -n 8 "$TIMELINE" > "$temp_file"
    cat >> "$temp_file" << EOF

## $TODAY ($DAY)

### What I worked on:
-

### What I captured:

### Context/Notes:

---
EOF
    tail -n +9 "$TIMELINE" >> "$temp_file"
    mv "$temp_file" "$TIMELINE"
fi

# Add capture entry
sed -i '' "/## $TODAY/,/### Context/{
    /### What I captured:/a\\
- \`$filename\` — $context$([ -n "$project" ] && echo " [Project: $project]")
}" "$TIMELINE" 2>/dev/null || {
    # Fallback for Linux sed
    sed -i "/## $TODAY/,/### Context/{
        /### What I captured:/a\\
- \`$filename\` — $context$([ -n "$project" ] && echo " [Project: $project]")
    }" "$TIMELINE"
}

echo ""
echo "════════════════════════════════════════"
echo "✅ Captured!"
echo ""
echo "   📁 File: $filename"
echo "   📍 Location: Quick-Capture/"
echo "   📝 Context: $context"
[ -n "$project" ] && echo "   🏷️  Project: $project"
echo ""
echo "   📅 Logged to _TIMELINE.md"
echo "════════════════════════════════════════"
