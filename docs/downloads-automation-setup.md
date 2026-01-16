# Downloads → Quick-Capture Automation

Three options from easiest to most automatic:

---

## Option 1: Apple Shortcut (Recommended)

### Create the Shortcut:
1. Open **Shortcuts** app
2. Click **+** to create new shortcut
3. Add these actions:
   - **Get Contents of Folder** → select `Downloads`
   - **Filter Files** → Where "Type" is not "Folder"
   - **Move File** → to `iCloud Drive/📥 INBOX/Quick-Capture`
4. Name it **"Sweep Downloads"**

### Automate it:
1. Go to **Automation** tab
2. Click **+** → **Time of Day**
3. Set to run **daily at 9pm** (or whenever)
4. Select your "Sweep Downloads" shortcut
5. Turn OFF "Ask Before Running"

---

## Option 2: Folder Action (Instant, Built-in)

This moves files THE MOMENT they land in Downloads:

1. Open **Automator** (search in Spotlight)
2. Choose **Folder Action**
3. At the top, set "Folder Action receives files added to" → **Downloads**
4. Add action: **Run Shell Script**
5. Paste this:

```bash
for f in "$@"; do
    mv "$f" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/📥 INBOX/Quick-Capture/"
done
```

6. Save as **"Move to Quick-Capture"**

Now every new download auto-moves to Quick-Capture instantly.

---

## Option 3: Scheduled Script (launchd)

For a daily sweep at a specific time:

### 1. Make the script executable:
```bash
chmod +x ~/path/to/gloss-manager/scripts/downloads-to-inbox.sh
```

### 2. Create the launchd plist:
```bash
cat > ~/Library/LaunchAgents/com.jisel.downloads-sweep.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jisel.downloads-sweep</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>~/path/to/gloss-manager/scripts/downloads-to-inbox.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>21</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
EOF
```

### 3. Load it:
```bash
launchctl load ~/Library/LaunchAgents/com.jisel.downloads-sweep.plist
```

---

## Which to choose?

| Option | Runs when | Effort | Best for |
|--------|-----------|--------|----------|
| Shortcut | Daily/manual | 2 min | Most people |
| Folder Action | Instantly on download | 5 min | "I want it gone immediately" |
| launchd | Scheduled time | 10 min | Power users |

**My recommendation:** Start with **Option 2 (Folder Action)** — it's built-in, instant, and you never have to think about it again.
