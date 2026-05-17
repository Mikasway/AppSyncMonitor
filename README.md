# App Sync Monitor

**Magisk module for GammaOS** - Automatically sync emulator saves between your device and Syncthing.

## The Problem (Simple Explanation)

You use **Syncthing** to backup your game saves to your PC.
You use **NetherSX2** or **Dolphin** emulators on your phone.

**But on Android 14+, they don't talk to each other automatically.** You have to manually copy files back and forth. Annoying!

**App Sync Monitor fixes this.** It's like a bridge that moves your saves automatically.

## What Happens (Step by Step)

### Before (Without this module)
1. You play a game, save it
2. You close the app
3. The save is stuck on your phone
4. Your PC doesn't get the update ❌

### After (With this module)
1. You play a game, save it
2. You close the app
3. **Module automatically copies the save to Syncthing**
4. **Syncthing syncs to your PC** ✅
5. Next time you play on another device, **your save is there** ✅

## How to Install

### Step 1: Get the Scripts Ready (Copy-Paste)

**Open ADB on your PC and go into your phone's shell:**

```
adb shell
su
```

**Create the first script** (copy everything between the `cat` and `EOF`):

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

**Create the second script:**

```bash
cat > /data/media/0/sync_save.sh << 'EOF'
#!/bin/sh
cp -r /data/media/0/Android/data/xyz.aethersx2.android/files/. /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/
cp -r /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/
EOF
chmod +x /data/media/0/sync_save.sh
```

**What these scripts do:**
- `sync_load.sh` = Copies saves FROM Syncthing TO the emulator (when you open the app)
- `sync_save.sh` = Copies saves FROM the emulator TO Syncthing (when you close the app)

**What's `u0_a190` and `u0_a181`?**
- `u0_a190` = Unique ID number for NetherSX2 app
- `u0_a181` = Unique ID number for Dolphin app
- Every app has its own number so Android knows which app is which

**What's `ext_data_rw`?**
- It means: "Give permission to read AND write files"
- Without this, the app couldn't save your game

**Simple translation:**
`chown -R u0_a181:ext_data_rw /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/`

= "Give Dolphin permission to read and write its save files"

### Step 2: Install the Module

1. Download the `AppSyncMonitor.zip` file
2. Open **Magisk Manager**
3. Tap **Modules** (bottom menu)
4. Tap the **+** button
5. Select `AppSyncMonitor.zip`
6. Wait for it to say "Success"
7. **Reboot your phone**

That's it! The module is now installed and running.

### Step 3: Configure Syncthing

Open **Syncthing-Fork** app and make sure you have two folders syncing:

1. **Folder 1 - NetherSX2 saves**
   - Device folder: `~/Android/data/xyz.aethersx2.android/files`
   - Syncs to: Your PC/Linux

2. **Folder 2 - Dolphin saves**
   - Device folder: `~/Android/data/org.dolphinemu.dolphinemu/files`
   - Syncs to: Your PC/Linux

(If you don't know how to set this up, see the separate Syncthing guide)

## How It Works (In Your Phone)

The module runs in the background and watches what apps you're using:

**When you launch NetherSX2:**
```
You tap NetherSX2 icon
    ↓
Module detects the launch
    ↓
Runs sync_load.sh
    ↓
Latest saves from Syncthing are copied to the emulator
    ↓
You can play!
```

**When you close NetherSX2:**
```
You close the app
    ↓
Module detects the closure
    ↓
Runs sync_save.sh
    ↓
Your saves are copied back to Syncthing
    ↓
Syncthing syncs to your PC
```

## What Those Technical Terms Mean

- **`chown u0_a190:ext_data_rw`** = "Give the NetherSX2 app permission to read/write these files"
  - `u0_a190` = The app's user ID (unique number for the app)
  - `ext_data_rw` = The group that has read/write access

- **`cp -r`** = Copy a folder and everything inside it

- **`~/Android/data/`** = Where Android stores app data on your phone

- **`Syncthing folder`** = The folder where Syncthing keeps your backup copies

## Troubleshooting

### "Module not working, saves aren't syncing"

**Check 1: Are the scripts there?**
```bash
adb shell ls -l /data/media/0/sync_*.sh
```
You should see two files. If not, repeat Step 1.

**Check 2: Is Syncthing running?**
Open Syncthing app and check if it says "Running". If not, start it.

**Check 3: Are your folders configured in Syncthing?**
In Syncthing app, go to Folders and check if NetherSX2 and Dolphin folders are listed.

### "Permission denied errors"

This usually means the app IDs are wrong. To find your correct app IDs:

```bash
adb shell stat /data/media/0/Android/data/xyz.aethersx2.android
```

Look for the line with `Uid:` - it shows something like `u0_a190`. Use that number in your scripts.

## Performance (Will it drain my battery?)

**No, it's very efficient:**
- The module only checks every 10 seconds if an app is launched/closed
- That's like checking your watch 6 times per minute
- Battery impact: almost nothing
- CPU impact: negligible

## Compatibility

- **Works on**: GammaOS with Magisk
- **Android version**: 11+
- **Other ROMs**: LineageOS, GrapheneOS, and most custom ROMs with Magisk

## License

MIT - Use freely, modify as you wish

## Need Help?

Open an issue on GitHub: https://github.com/Mikasway/AppSyncMonitor/issues
