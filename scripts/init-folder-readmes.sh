#!/bin/bash
# Creates README breadcrumbs and _CONTEXT.md journals in each folder

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# ═══════════════════════════════════════════════════════════════
# 📥 INBOX
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/📥 INBOX/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  📥 INBOX — Transit Station, NOT Storage                      ║
╚═══════════════════════════════════════════════════════════════╝

RULE: Nothing lives here permanently. Weekly sweep on Sundays.

FOLDERS:
  To-Sort/       → "Downloaded, haven't decided where it goes"
  Waiting-On/    → "Needs input from someone else"
  Quick-Capture/ → "Screenshots, voice memos — process weekly"

⏰ MAX LIFESPAN: 2 weeks, then → 📦 DEEP ARCHIVE
EOF

cat > "$ICLOUD/📥 INBOX/_CONTEXT.md" << 'EOF'
# 📥 INBOX — What's Happening

> Last updated: (auto-updates when you run the context script)

---

## 🔥 Recently Added
<!-- Auto-populated by context watcher -->

## 🎯 Looks Like You're Working On
<!-- AI-detected patterns -->

## ✅ Quick Wins — Process These Now
- [ ] Check To-Sort (anything older than 3 days?)
- [ ] Clear Quick-Capture (delete junk, keep gems)
- [ ] Review Waiting-On (any blockers cleared?)

---
*Run `./scripts/update-context.sh` to refresh*
EOF

# ═══════════════════════════════════════════════════════════════
# 🔥 ACTIVE
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/🔥 ACTIVE/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  🔥 ACTIVE — This Week's Focus                                ║
╚═══════════════════════════════════════════════════════════════╝

RULE: If you're not touching it THIS WEEK, it doesn't belong here.

FOLDERS:
  Mattegloss-ThisWeek/ → Active client work, content in progress
  BYJISEL-ThisWeek/    → Brand shoots, edits, deliverables
  Personal-ThisWeek/   → Life admin, side projects

🧹 END OF WEEK: Archive completed work → 📦 DEEP ARCHIVE/2025/
EOF

cat > "$ICLOUD/🔥 ACTIVE/_CONTEXT.md" << 'EOF'
# 🔥 ACTIVE — Current Sprint

> Last updated: (auto-updates)

---

## 🎯 This Week's Focus
<!-- What you're actively grinding on -->

## 📊 Activity Heatmap
<!-- Which folders are getting the most action -->

## ✅ Ship It — Ready to Deliver
- [ ] Review Mattegloss deliverables
- [ ] Check BYJISEL exports
- [ ] Clear completed personal tasks

## 🏆 Wins This Week
<!-- Celebrate what you finished! -->

---
*Run `./scripts/update-context.sh` to refresh*
EOF

# ═══════════════════════════════════════════════════════════════
# 🏛️ REFERENCE
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/🏛️ REFERENCE/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  🏛️ REFERENCE — Permanent Knowledge Base                     ║
╚═══════════════════════════════════════════════════════════════╝

RULE: Stuff you need to FIND later, not work on now.

FOLDERS:
  Legal-Licenses-Contracts/ → LLC docs, agreements, licenses
  Brand-Assets/             → Logos, fonts, style guides
  Financial-Records/        → Invoices, receipts, tax docs
  How-To-Guides/            → SOPs, tutorials, cheat sheets

🔍 NAMING: Use searchable names like "2025-01_Mattegloss-LLC-Agreement.pdf"
EOF

cat > "$ICLOUD/🏛️ REFERENCE/_CONTEXT.md" << 'EOF'
# 🏛️ REFERENCE — Your Knowledge Vault

> Last updated: (auto-updates)

---

## 📁 What's Here
<!-- Summary of reference materials -->

## 🔍 Recently Accessed
<!-- What you've been looking up -->

## ⚠️ Needs Attention
- [ ] Any contracts expiring soon?
- [ ] Financial records up to date?
- [ ] Brand assets current version?

## 🗂️ Filing Backlog
<!-- Reference items sitting in INBOX that belong here -->

---
*Run `./scripts/update-context.sh` to refresh*
EOF

# ═══════════════════════════════════════════════════════════════
# 📸 MEDIA VAULT
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/📸 MEDIA VAULT/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  📸 MEDIA VAULT — All Your Visual Assets                      ║
╚═══════════════════════════════════════════════════════════════╝

RULE: Media that's DONE processing lives here.

FOLDERS:
  Ready-To-Post/ → Final exports, approved for publishing
  Raw-Footage/   → Unedited source files, B-roll
  Portfolio/     → Best work, case studies, highlights

📏 NAMING: "YYYY-MM-DD_Client_Description.ext"
   Example: "2025-01-15_Mattegloss_ProductShoot-Final.mp4"
EOF

cat > "$ICLOUD/📸 MEDIA VAULT/_CONTEXT.md" << 'EOF'
# 📸 MEDIA VAULT — Content Library

> Last updated: (auto-updates)

---

## 🚀 Ready To Post
<!-- Content queued for publishing -->

## 🎬 In The Vault
<!-- Summary of raw footage and assets -->

## ✅ Content Pipeline
- [ ] Any raw footage needs editing?
- [ ] Portfolio updated with recent wins?
- [ ] Ready-To-Post queue healthy?

## 📈 Stats
<!-- File counts, storage used, recent additions -->

---
*Run `./scripts/update-context.sh` to refresh*
EOF

# ═══════════════════════════════════════════════════════════════
# 🧠 STRATEGIC THINKING
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/🧠 STRATEGIC THINKING/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  🧠 STRATEGIC THINKING — Big Picture Planning                 ║
╚═══════════════════════════════════════════════════════════════╝

RULE: Ideas, plans, and decisions — not day-to-day work.

FOLDERS:
  Current-Initiatives/ → Active strategies, ongoing plans
  Decision-Archive/    → Past decisions with reasoning (learn from them!)

💡 TIP: When you make a big decision, write a quick note:
   "What I decided, why, what I expected to happen"
   Future you will thank you.
EOF

cat > "$ICLOUD/🧠 STRATEGIC THINKING/_CONTEXT.md" << 'EOF'
# 🧠 STRATEGIC THINKING — Your Brain's Backup

> Last updated: (auto-updates)

---

## 🎯 Active Initiatives
<!-- What big-picture stuff you're working toward -->

## 💭 Recent Thinking
<!-- What strategic docs you've been touching -->

## ✅ Strategic Review
- [ ] Any initiatives stalled?
- [ ] Decisions that need revisiting?
- [ ] New ideas captured?

## 🔮 Patterns Detected
<!-- Connections between your strategic work -->

---
*Run `./scripts/update-context.sh` to refresh*
EOF

# ═══════════════════════════════════════════════════════════════
# 📦 DEEP ARCHIVE
# ═══════════════════════════════════════════════════════════════

cat > "$ICLOUD/📦 DEEP ARCHIVE/_README.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║  📦 DEEP ARCHIVE — Cold Storage                               ║
╚═══════════════════════════════════════════════════════════════╝

RULE: Done, but might need someday. Out of sight, searchable.

FOLDERS:
  2024/           → Everything completed/archived from 2024
  2025/           → This year's archived work
  Legacy-Systems/ → Old backups, deprecated stuff

📏 NAMING: Prefix with date "YYYY-MM_Description"
   Example: "2025-01_Mattegloss-Q4-Campaign/"

🔍 CAN'T FIND SOMETHING? Use Spotlight: kind:folder date:2024
EOF

cat > "$ICLOUD/📦 DEEP ARCHIVE/_CONTEXT.md" << 'EOF'
# 📦 DEEP ARCHIVE — Time Capsule

> Last updated: (auto-updates)

---

## 📅 Recently Archived
<!-- What you've put to rest recently -->

## 📊 Archive Stats
<!-- Size, file counts by year -->

## ✅ Archive Health
- [ ] 2024 folder organized?
- [ ] Legacy-Systems documented?
- [ ] Anything in INBOX older than 2 weeks? → Archive it

## 🕰️ On This Day Last Year
<!-- What you were working on — fun context! -->

---
*Run `./scripts/update-context.sh` to refresh*
EOF

echo "✅ README and _CONTEXT.md files created in all folders!"
