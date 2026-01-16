#!/bin/bash
# iCloud Drive Folder Structure - Discussed with Jisel
# Run this on your Mac: ./scripts/create-icloud-folders.sh

ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

if [ ! -d "$ICLOUD_DIR" ]; then
    echo "❌ iCloud Drive not found at: $ICLOUD_DIR"
    exit 1
fi

cd "$ICLOUD_DIR" || exit 1

# 📥 INBOX - Transit station, not storage
mkdir -p "📥 INBOX/To-Sort"          # Downloaded, haven't decided where it goes
mkdir -p "📥 INBOX/Waiting-On"       # Needs input from someone else
mkdir -p "📥 INBOX/Quick-Capture"    # Screenshots, voice memos, random saves

# 🔥 ACTIVE - This week's work
mkdir -p "🔥 ACTIVE/Mattegloss-ThisWeek"
mkdir -p "🔥 ACTIVE/BYJISEL-ThisWeek"
mkdir -p "🔥 ACTIVE/Personal-ThisWeek"

# 🏛️ REFERENCE - Permanent reference materials
mkdir -p "🏛️ REFERENCE/Legal-Licenses-Contracts"
mkdir -p "🏛️ REFERENCE/Brand-Assets"
mkdir -p "🏛️ REFERENCE/Financial-Records"
mkdir -p "🏛️ REFERENCE/How-To-Guides"

# 📸 MEDIA VAULT - All media files
mkdir -p "📸 MEDIA VAULT/Ready-To-Post"
mkdir -p "📸 MEDIA VAULT/Raw-Footage"
mkdir -p "📸 MEDIA VAULT/Portfolio"

# 🧠 STRATEGIC THINKING - Planning & decisions
mkdir -p "🧠 STRATEGIC THINKING/Current-Initiatives"
mkdir -p "🧠 STRATEGIC THINKING/Decision-Archive"

# 📦 DEEP ARCHIVE - Long-term storage
mkdir -p "📦 DEEP ARCHIVE/2024"
mkdir -p "📦 DEEP ARCHIVE/2025"
mkdir -p "📦 DEEP ARCHIVE/Legacy-Systems"

echo ""
echo "✅ iCloud Drive folder structure created!"
echo ""
echo "📍 Location: $ICLOUD_DIR"
echo ""
echo "─────────────────────────────────────────"
echo "WEEKLY RITUAL (15 min, Sundays):"
echo "─────────────────────────────────────────"
echo "1. Quick-Capture → Drag meaningful stuff to To-Sort, delete rest"
echo "2. To-Sort → Sort in 10 min, stuck items after 2 weeks → DEEP ARCHIVE"
echo "3. Waiting-On → Check if blockers cleared, move to ACTIVE or archive"
echo ""
echo "Rule: Inbox is a TRANSIT STATION, not a storage unit."
