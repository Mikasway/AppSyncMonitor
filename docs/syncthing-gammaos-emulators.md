# 🎮 Sync emulator save data on GammaOS with Syncthing

> Tested on **GammaOS** (Anbernic devices) with **NetherSX2-patched** and **Dolphin**  
> Works for any emulator storing data in `Android/data/`

## 📋 Prerequisites

- GammaOS (includes **Magisk root** by default)
- [Syncthing-Fork](https://f-droid.org/packages/com.github.catfriend1.syncthingandroid/) installed via F-Droid
- [MacroDroid](https://play.google.com/store/apps/details?id=com.arlosoft.macrodroid) installed
- [ADB Platform Tools](https://developer.android.com/tools/releases/platform-tools) on your PC
- A USB cable

---

## 🔌 Step 1 — Connect via ADB

1. On your device: **Settings → About → tap Build Number 7 times**
2. **Settings → Developer Options → Enable USB Debugging**
3. On your PC, open a terminal in the platform-tools folder:

```cmd
adb devices
```

> A popup appears on your device → tap **Allow**

You should see your device listed:
```
96783427863737  device
```

---

## 🔑 Step 2 — Get root access

```cmd
adb shell
su
```

> A Magisk popup appears on your device → tap **Allow**

Your prompt should now show `#` indicating root access.

---

## 📁 Step 3 — Configure Syncthing-Fork

In Syncthing-Fork, set your sync folder path to:
```
~/Syncthing/Android/data/<package_name>/files
```

For example:
- NetherSX2 → `~/Syncthing/Android/data/xyz.aethersx2.android/files`
- Dolphin → `~/Syncthing/Android/data/org.dolphinemu.dolphinemu/files`

> ⚠️ Do **not** point Syncthing directly to `Android/data/` — Android 13/14 blocks write access there even with root via ADB.

---

## 🔍 Step 4 — Find the UID of each emulator app

For each emulator, run (in the ADB root shell):

```sh
stat /data/media/0/Android/data/<package_name>
```

Note the `Uid` value, for example:
```
Uid: (10190/ u0_a190)   Gid: ( 1078/ext_data_rw)
```

| App | Package | UID (example) |
|-----|---------|---------------|
| NetherSX2 | `xyz.aethersx2.android` | `u0_a190` |
| Dolphin | `org.dolphinemu.dolphinemu` | `u0_a181` |

> ⚠️ UIDs vary per device/install — always check with `stat`.

---

## 📂 Step 5 — Prepare the destination folders

For each emulator, make sure the `files` folder exists and has correct permissions:

```sh
mkdir -p /data/media/0/Android/data/<package_name>/files
chown u0_a190:ext_data_rw /data/media/0/Android/data/<package_name>/files
chmod 2770 /data/media/0/Android/data/<package_name>/files
```

---

## 📝 Step 6 — Create the sync script

```sh
cat > /data/media/0/sync_emulators.sh << 'EOF'
#!/bin/sh

# NetherSX2
cp -r /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/. /data/media/0/Android/data/xyz.aethersx2.android/files/
chown -R u0_a190:ext_data_rw /data/media/0/Android/data/xyz.aethersx2.android/files/

# Dolphin
cp -r /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/
chown -R u0_a181:ext_data_rw /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/

EOF
chmod +x /data/media/0/sync_emulators.sh
```

> To add more emulators, just add a new block following the same pattern.

---

## ⚙️ Step 7 — Automate with MacroDroid

1. Open **MacroDroid** → **Add Macro**
2. **Trigger** → *Application Launched* → select your emulator (repeat for each)
3. **Action** → *Shell Script* → enable **Use Root** → enter:
```
/data/media/0/sync_emulators.sh
```
4. Save the macro

> The script will run automatically every time you launch an emulator, copying the latest synced files and fixing permissions.

---

## ✅ Testing

1. Create a save on your PC/Linux machine
2. Let Syncthing sync
3. Launch the emulator on GammaOS
4. MacroDroid triggers the script → files are copied with correct permissions
5. Your save should appear in-game ✓

To check MacroDroid logs: **☰ Menu → Macro Log**

---

## 🔄 Reverse sync (device → PC)

Add a second MacroDroid macro:
- **Trigger** → *Application Closed* → select your emulator
- **Action** → same script

This ensures saves made on the device are copied back to the Syncthing folder and synced to your PC.

> ⚠️ Be careful with conflicts — Syncthing may need conflict resolution settings configured.

---

## 🗒️ Notes

- This guide uses `/data/media/0/` instead of `/sdcard/` because Android 13/14 scoped storage blocks access to `Android/data/` via `/sdcard/` even as root
- Symlinks do **not** work as a workaround — NetherSX2 and Dolphin do not follow them
- GammaOS Next includes *Relaxed Scoped Storage* which may simplify this in future versions
- UIDs are assigned at install time and may change if you reinstall an app — re-run `stat` if things stop working

---

## 📦 Packages reference

| App | Package name |
|-----|-------------|
| NetherSX2-patched | `xyz.aethersx2.android` |
| Dolphin Emulator | `org.dolphinemu.dolphinemu` |
| Syncthing-Fork | `com.github.catfriend1.syncthingandroid` |

---

*Guide written based on real troubleshooting session — GammaOS on Anbernic RG / May 2026*
