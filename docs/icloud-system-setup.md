# iCloud Drive Organization System — Complete Setup Guide

> Never rebuild the wheel again. This system tracks what you're doing automatically.

---

## Quick Start (5 minutes)

### 1. Create the folder structure
```bash
./scripts/create-icloud-folders.sh
```

### 2. Initialize README files and context journals
```bash
./scripts/init-folder-readmes.sh
```

### 3. Run your first context update
```bash
./scripts/update-context.sh
```

### 4. See your dashboard
```bash
./scripts/dashboard.sh
```

---

## Finder Sidebar Setup

Drag these folders to your Finder sidebar for one-click access:

1. Open Finder
2. Navigate to `iCloud Drive`
3. **Drag these to sidebar** (in this order):
   - `📥 INBOX` — Your daily landing spot
   - `🔥 ACTIVE` — Where you actually work
   - `📸 MEDIA VAULT` — Quick access to content

### Pro tip: Keyboard shortcuts
- `Cmd + 1` through `Cmd + 9` jump to sidebar items
- Put INBOX as #1 for instant access

---

## Auto-Move Downloads to Quick-Capture

### Option A: Folder Action (Recommended — instant, built-in)

1. Open **Automator** → New → **Folder Action**
2. Set folder to **Downloads**
3. Add **Run Shell Script**:
```bash
for f in "$@"; do
    mv "$f" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/📥 INBOX/Quick-Capture/"
done
```
4. Save as "Move to Quick-Capture"

### Option B: Apple Shortcut (daily sweep)

1. **Shortcuts** → New shortcut
2. Add: **Get Contents of Folder** → Downloads
3. Add: **Filter Files** → Type is not Folder
4. Add: **Move File** → `iCloud Drive/📥 INBOX/Quick-Capture`
5. **Automation** → Time of Day → 9pm daily

---

## The Scripts

| Script | What it does | When to run |
|--------|--------------|-------------|
| `create-icloud-folders.sh` | Creates folder structure | Once |
| `init-folder-readmes.sh` | Adds README + _CONTEXT.md files | Once |
| `update-context.sh` | Refreshes all context journals | Weekly or anytime |
| `dashboard.sh` | Shows gamified command center | Daily |
| `stale-detector.sh` | Finds forgotten items in INBOX | Weekly |
| `watch-folders.sh` | Auto-logs every file change | Run in background |
| `downloads-to-inbox.sh` | Moves Downloads to Quick-Capture | Manual or scheduled |

---

## The Weekly Ritual (15 minutes, Sundays)

```
┌─────────────────────────────────────────────────────────────┐
│  SUNDAY SWEEP                                               │
├─────────────────────────────────────────────────────────────┤
│  1. Run ./scripts/dashboard.sh — see your status            │
│  2. Run ./scripts/stale-detector.sh — find forgotten items  │
│  3. Clear Quick-Capture (delete junk, keep gems)            │
│  4. Sort To-Sort (10 min max)                               │
│  5. Check Waiting-On (any blockers cleared?)                │
│  6. Archive completed ACTIVE work                           │
│  7. Run ./scripts/update-context.sh — refresh journals      │
└─────────────────────────────────────────────────────────────┘
```

---

## Context Journals Explained

Every zone has a `_CONTEXT.md` file that auto-updates with:

- **What's in there** — file counts, recent additions
- **What you're probably working on** — detected patterns
- **Checklist of actions** — gamified tasks to complete
- **Health score** — how well you're maintaining the zone

**The magic:** When you come back to a project after weeks/months, just open `_CONTEXT.md` to instantly rebuild your mental state.

---

## File Naming Conventions

### For archives:
```
YYYY-MM_ProjectName_Description.ext
2025-01_Mattegloss_Q4-Campaign.zip
```

### For media:
```
YYYY-MM-DD_Client_Description.ext
2025-01-15_BYJISEL_ProductShoot-Final.mp4
```

### For reference docs:
```
YYYY-MM_Category_Description.ext
2025-01_LLC_Operating-Agreement.pdf
```

---

## Troubleshooting

### "I can't find anything"
- Use Spotlight: `kind:pdf contract 2024`
- Check `_CONTEXT.md` in each zone
- Run `./scripts/dashboard.sh` to see recent activity

### "INBOX is overwhelming"
- Run `./scripts/stale-detector.sh`
- Archive anything over 2 weeks old
- The rule: If you can't sort it in 10 seconds, archive it

### "I forgot what I was working on"
- Open `🔥 ACTIVE/_CONTEXT.md`
- Check `_activity-log.md` in iCloud Drive root
- Run `./scripts/dashboard.sh` for recent files

---

## Background Watcher (Optional)

To auto-log every file that enters your system:

```bash
# Install fswatch first
brew install fswatch

# Start the watcher (runs in background)
./scripts/watch-folders.sh &

# Stop it later
./scripts/watch-folders.sh stop
```

This creates `_activity-log.md` in your iCloud Drive root — a timestamped record of everything that's happened.

---

## The Philosophy

> **Inbox is a transit station, not a storage unit.**

- Nothing lives in INBOX permanently
- ACTIVE is for THIS WEEK only
- REFERENCE is for finding, not working
- ARCHIVE is where finished things rest
- Context journals rebuild your brain automatically

---

*Created by Jisel's iCloud organization system*
