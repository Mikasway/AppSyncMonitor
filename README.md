# 🎮 App Sync Monitor

> **Automatically sync your emulator saves between your phone and Syncthing** — No more manual file copying!

A Magisk module for GammaOS that seamlessly synchronizes game saves for NetherSX2, Dolphin, and other emulators.

---

## 🤔 The Problem

You have:
- 📱 An emulator (NetherSX2, Dolphin) on your phone
- 💾 Syncthing backing up your saves to your PC
- 🤯 But they **don't talk to each other** on Android 14+

**Result:** You manually copy files back and forth. Annoying! 😩

---

## ✨ What This Module Does

Instead of manual copying, the module works like a **bridge** between your emulator and Syncthing:

```
Game Save → Module → Syncthing → Your PC ✅
```

**Automatically, every time you play!**

### The Magic

| Before | After |
|--------|-------|
| Play game → Close app → Save stuck on phone ❌ | Play game → Close app → Save syncs to PC ✅ |
| Manual copy every time 😫 | Automatic sync in background 🤖 |

---

## 🚀 Quick Start (5 Minutes)

### 1️⃣ Setup ADB (Your PC Connection)

**Download & Setup:**
- Get [Android SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools)
- Extract to `C:\adb\` on Windows
- Enable USB Debugging on your phone:
  - Settings → About → Tap "Build Number" 7 times
  - Settings → Developer Options → Enable "USB Debugging"

**Connect your phone and test:**
```cmd
cd C:\adb
adb devices
```

You should see your phone listed ✅

### 2️⃣ Create the Sync Scripts

Open PowerShell and connect to your phone:

```cmd
adb shell
su
```

A popup appears on your phone → Tap **Allow**

**Now paste this entire block** (right-click → Paste):

```bash
cat > /data/media/0/sync_load.sh << 'EOF'
#!/bin/sh
cp -r /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/. /data/media/0/Android/data/xyz.aethersx2.android/files/
chown -R u0_a190:ext_data_rw /data/media/0/Android/data/xyz.aethersx2.android/files/
cp -r /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/
chown -R u0_a181:ext_data_rw /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/
EOF
chmod +x /data/media/0/sync_load.sh
```

**Then paste this:**

```bash
cat > /data/media/0/sync_save.sh << 'EOF'
#!/bin/sh
cp -r /data/media/0/Android/data/xyz.aethersx2.android/files/. /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/
cp -r /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/
EOF
chmod +x /data/media/0/sync_save.sh
```

✅ **Done!** You've created the sync scripts.

**What they do:**
- 📥 `sync_load.sh` = Loads saves from Syncthing when you open an emulator
- 📤 `sync_save.sh` = Saves back to Syncthing when you close the app

### 3️⃣ Install the Module

1. Download `AppSyncMonitor.zip`
2. Open **Magisk Manager** → Tap **Modules** (bottom menu)
3. Tap the **➕** button
4. Select the zip file → Wait for "Success"
5. **Reboot your phone**

🎉 **Module installed!**

### 4️⃣ Configure Syncthing

Open **Syncthing-Fork** and add these two sync folders:

**Folder 1 - NetherSX2 Saves**
```
Device path: ~/Android/data/xyz.aethersx2.android/files
Sync to: Your PC/Linux
```

**Folder 2 - Dolphin Saves**
```
Device path: ~/Android/data/org.dolphinemu.dolphinemu/files
Sync to: Your PC/Linux
```

Done! ✅

---

## 🎯 How It Actually Works

```
YOU LAUNCH NETHER → Module detects it
                  ↓
            sync_load.sh runs
                  ↓
    Syncthing saves copied to emulator
                  ↓
            YOU PLAY! 🎮
                  ↓
       YOU CLOSE THE APP
                  ↓
            sync_save.sh runs
                  ↓
    Saves copied back to Syncthing
                  ↓
         PC receives update ✅
```

---

## 📚 Understanding the Technical Stuff

### What's `u0_a190` and `u0_a181`?

Each app has a unique ID number:
- **NetherSX2** = `u0_a190`
- **Dolphin** = `u0_a181`
- WhatsApp = `u0_a123` (example)

Android uses these numbers to know "this is Dolphin" or "this is NetherSX2"

### What's `ext_data_rw`?

It means: **"Give this app permission to read AND write files"**

**In plain English:**
```
chown -R u0_a181:ext_data_rw /path/to/files
```
= "Give Dolphin permission to read and write its save files"

### What do those commands mean?

- `cp -r` = Copy a folder and everything inside it
- `chown` = Change ownership (who owns the files)
- `chmod +x` = Make a script runnable

---

## 🔧 Troubleshooting

### ❌ "Saves aren't syncing"

**Check 1: Do the scripts exist?**
```bash
adb shell ls -l /data/media/0/sync_*.sh
```
You should see two files. If not, redo Step 2.

**Check 2: Is Syncthing running?**
- Open Syncthing app → Should say "Running"
- If not, start it

**Check 3: Are folders configured?**
- Syncthing app → Check Folders section
- NetherSX2 and Dolphin folders should be listed

### ❌ "Permission denied"

Your app IDs might be wrong. Find the correct ones:

```bash
adb shell stat /data/media/0/Android/data/xyz.aethersx2.android
```

Look for the line with `Uid: (XXXXX/ u0_aXXX)` — use that number in your scripts.

---

## ⚡ Performance Impact

- **Battery drain:** Almost nothing (checks every 10 seconds)
- **CPU usage:** Minimal
- **Storage:** None (just copies existing files)

**In real terms:** You won't notice any difference in battery life.

---

## 💾 Compatibility

| Aspect | Support |
|--------|---------|
| **OS** | Android 11+ |
| **ROM** | GammaOS, LineageOS, GrapheneOS, most custom ROMs |
| **Device** | Any phone with Magisk |
| **Emulators** | NetherSX2, Dolphin, customizable for others |

---

## 🎓 Advanced: Add More Emulators

Want to sync saves for a different emulator?

1. Find the app's UID:
```bash
adb shell stat /data/media/0/Android/data/com.your.app
```

2. Edit `/data/adb/modules/AppSyncMonitor/service.sh`

3. Add your app to the monitoring loop (ask in GitHub issues if stuck)

---

## ❓ FAQ

**Q: Will this drain my battery?**
A: No. The module only checks every 10 seconds if an app is open. Minimal impact.

**Q: Does it work offline?**
A: Yes! It copies files locally. Syncthing syncs when you have internet.

**Q: Can I use it for other apps?**
A: Yes! With some technical knowledge. Open an issue on GitHub.

**Q: Is it safe?**
A: Completely. It just copies your existing files. No data is lost.

---

## 📄 License

MIT - Use, modify, and share freely

---

## 🆘 Need Help?

Something not working? Found a bug?

**Open an issue on GitHub:**
👉 https://github.com/Mikasway/AppSyncMonitor/issues

Include:
- What happened
- Your phone model & Android version
- Which emulator you're using
- Error message (if any)

---

**Made with ❤️ for the GammaOS community**
