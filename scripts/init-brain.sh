#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# 🧠 GLOSS BRAIN — Initialize the central nervous system
# ═══════════════════════════════════════════════════════════════════════════
# Creates the master brain file that ties everything together.

ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
BRAIN="$ICLOUD/_GLOSS_BRAIN.md"
PROJECTS="$ICLOUD/_PROJECTS.md"
TIMELINE="$ICLOUD/_TIMELINE.md"
YEAR=$(date "+%Y")

echo "🧠 Initializing Gloss Brain..."

# ═══════════════════════════════════════════════════════════════
# Master Brain File
# ═══════════════════════════════════════════════════════════════

cat > "$BRAIN" << 'EOF'
# 🧠 GLOSS BRAIN — Your Digital Command Center

> **This is your single source of truth.**
> Everything connects here. When you're lost, start here.

---

## 🎯 RIGHT NOW

### What I'm Actively Working On
<!-- Update this whenever you switch contexts -->

- [ ] **Project:**
- [ ] **Project:**
- [ ] **Project:**

### Today's Top 3
<!-- Reset each morning -->

1. [ ]
2. [ ]
3. [ ]

### Waiting On (Blocked)
<!-- Things you can't move forward until someone else acts -->

| What | Who | Since | Follow-up |
|------|-----|-------|-----------|
|      |     |       |           |

---

## 🔥 ACTIVE PROJECTS

<!-- Each project links files across zones -->

### Project: [Name]
- **Status:** 🟢 Active / 🟡 Paused / 🔴 Blocked
- **Goal:**
- **Files:**
  - `📥 INBOX/...` —
  - `🔥 ACTIVE/...` —
  - `🏛️ REFERENCE/...` —
- **Next action:**
- **Notes:**

---

### Project: [Name]
- **Status:**
- **Goal:**
- **Files:**
- **Next action:**
- **Notes:**

---

## 📅 THIS WEEK

### Goals
- [ ]
- [ ]
- [ ]

### Wins (celebrate these!)
-

### Lessons Learned
-

---

## 🧭 QUICK NAVIGATION

| Zone | What's There | Open |
|------|--------------|------|
| [📥 INBOX](./%F0%9F%93%A5%20INBOX/_CONTEXT.md) | Incoming, unsorted | `Cmd+1` |
| [🔥 ACTIVE](./%F0%9F%94%A5%20ACTIVE/_CONTEXT.md) | This week's work | `Cmd+2` |
| [🏛️ REFERENCE](./%F0%9F%8F%9B%EF%B8%8F%20REFERENCE/_CONTEXT.md) | Permanent docs | `Cmd+3` |
| [📸 MEDIA](./%F0%9F%93%B8%20MEDIA%20VAULT/_CONTEXT.md) | Content library | `Cmd+4` |
| [🧠 STRATEGIC](./%F0%9F%A7%A0%20STRATEGIC%20THINKING/_CONTEXT.md) | Big picture | `Cmd+5` |
| [📦 ARCHIVE](./%F0%9F%93%A6%20DEEP%20ARCHIVE/_CONTEXT.md) | Completed work | `Cmd+6` |

---

## 💭 BRAIN DUMP

<!-- Quick thoughts, ideas, random notes — process weekly -->



---

## 📊 SYSTEM STATUS

> Auto-updated by `./scripts/update-brain.sh`

| Metric | Value | Status |
|--------|-------|--------|
| INBOX items | - | - |
| Stale items | - | - |
| Active files | - | - |
| Content ready | - | - |
| Health score | - | - |

*Last updated: never*

---

## 🔗 RELATED FILES

- [_TIMELINE.md](./_TIMELINE.md) — Chronological activity log
- [_PROJECTS.md](./_PROJECTS.md) — Full project database
- [_activity-log.md](./_activity-log.md) — Auto-generated file log

---

*This is your home base. When in doubt, come here.*
EOF

echo "  ✓ Created _GLOSS_BRAIN.md"

# ═══════════════════════════════════════════════════════════════
# Projects Database
# ═══════════════════════════════════════════════════════════════

cat > "$PROJECTS" << EOF
# 📁 PROJECT DATABASE

> All your projects in one place. Link files, track status, capture context.

---

## Active Projects

### 🟢 [Project Name]
- **Started:** $(date "+%Y-%m-%d")
- **Goal:** What are you trying to achieve?
- **Status:** In progress
- **Zone files:**
  - \`📥 INBOX/\` —
  - \`🔥 ACTIVE/\` —
  - \`🏛️ REFERENCE/\` —
  - \`📸 MEDIA/\` —
- **Timeline:**
  - $(date "+%Y-%m-%d"): Started project
- **Next action:**
- **Notes:**

---

## Template (copy this for new projects)

### 🟢 [Project Name]
- **Started:** YYYY-MM-DD
- **Goal:**
- **Status:** Planning / In progress / Review / Complete
- **Zone files:**
  - \`📥 INBOX/\` —
  - \`🔥 ACTIVE/\` —
  - \`🏛️ REFERENCE/\` —
  - \`📸 MEDIA/\` —
- **Timeline:**
  - YYYY-MM-DD:
- **Next action:**
- **Notes:**

---

## Completed Projects

<!-- Move projects here when done. Keep for reference! -->

---

## Someday/Maybe

<!-- Ideas for future projects -->

-

EOF

echo "  ✓ Created _PROJECTS.md"

# ═══════════════════════════════════════════════════════════════
# Timeline / Journal
# ═══════════════════════════════════════════════════════════════

cat > "$TIMELINE" << EOF
# 📅 TIMELINE — Your Activity Journal

> Chronological record of what happened. Auto-updated + manual entries.
> When you forget what you were doing, search here.

---

## $(date "+%Y-%m-%d") ($(date "+%A"))

### What I worked on:
-

### What I captured:
-

### Context/Notes:


---

## Template (copy for new days)

## YYYY-MM-DD (Day)

### What I worked on:
-

### What I captured:
-

### Context/Notes:


---

<!-- Older entries below -->

EOF

echo "  ✓ Created _TIMELINE.md"

echo ""
echo "🧠 Gloss Brain initialized!"
echo ""
echo "   📍 _GLOSS_BRAIN.md  — Your home base (start here!)"
echo "   📁 _PROJECTS.md     — Project database"
echo "   📅 _TIMELINE.md     — Activity journal"
echo ""
