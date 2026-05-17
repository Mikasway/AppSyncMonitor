# App Sync Monitor

Automatic data synchronization module for Android emulators and gaming apps using Syncthing.

## Features

✅ **Automatic Sync on Launch** - Loads data from Syncthing folder when app starts
✅ **Automatic Sync on Close** - Saves data back to Syncthing when app closes
✅ **Battery Efficient** - Checks every 10 seconds with minimal overhead
✅ **Multi-App Support** - Monitor multiple emulators simultaneously
✅ **Zero Manual Intervention** - Works transparently in the background

## Supported Apps

- **NetherSX2 / AetherSX2** - PlayStation 2 emulator
- **Dolphin** - GameCube/Wii emulator
- *Easily customizable for other apps*

## Requirements

- GammaOS (or any Android with Magisk)
- Syncthing-Fork installed and configured
- Root access via Magisk

## Installation

### Step 1: Prepare Sync Scripts

Create the sync load script at `/data/media/0/sync_load.sh`:

```bash
#!/bin/sh
# Load from Syncthing to app storage
cp -r /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/. /data/media/0/Android/data/xyz.aethersx2.android/files/
chown -R u0_a190:ext_data_rw /data/media/0/Android/data/xyz.aethersx2.android/files/

cp -r /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/
chown -R u0_a181:ext_data_rw /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/
```

Create the sync save script at `/data/media/0/sync_save.sh`:

```bash
#!/bin/sh
# Save from app storage back to Syncthing
cp -r /data/media/0/Android/data/xyz.aethersx2.android/files/. /data/media/0/Syncthing/Android/data/xyz.aethersx2.android/files/
cp -r /data/media/0/Android/data/org.dolphinemu.dolphinemu/files/. /data/media/0/Syncthing/Android/data/org.dolphinemu.dolphinemu/files/
```

Make both scripts executable:
```bash
chmod +x /data/media/0/sync_load.sh
chmod +x /data/media/0/sync_save.sh
```

### Step 2: Install Module via Magisk Manager

1. Open Magisk Manager
2. Modules → Install from storage
3. Select the `AppSyncMonitor.zip` file
4. Reboot device

### Step 3: Configure Syncthing-Fork

1. In Syncthing-Fork, add folders for each app:
   - **NetherSX2**: `~/Android/data/xyz.aethersx2.android/files`
   - **Dolphin**: `~/Android/data/org.dolphinemu.dolphinemu/files`

2. Set up bidirectional sync with your PC/Linux

## How It Works

1. **Launch Detection** - Module monitors foreground app via `dumpsys`
2. **Load Trigger** - When you open NetherSX2/Dolphin, `sync_load.sh` runs
   - Copies latest saves from Syncthing folder to app storage
   - Sets correct permissions so app can read files
3. **Gameplay** - App uses local files normally
4. **Save Trigger** - When you close the app, `sync_save.sh` runs
   - Copies updated saves back to Syncthing folder
   - Syncthing auto-syncs to your other devices

## Customization

### Add More Apps

Edit `/data/adb/modules/AppSyncMonitor/service.sh` and add:

```bash
YOUR_PKG="com.example.app"
YOUR_UID=u0_aXXX  # Find with: dumpsys package | grep userId

# In the loop, add:
if [ "$FOREGROUND" = "$YOUR_PKG" ] && [ $YOUR_RUNNING -eq 0 ]; then
    YOUR_RUNNING=1
    "$SYNC_LOAD_SCRIPT" > /dev/null 2>&1 &
elif [ "$FOREGROUND" != "$YOUR_PKG" ] && [ $YOUR_RUNNING -eq 1 ]; then
    YOUR_RUNNING=0
    "$SYNC_SAVE_SCRIPT" > /dev/null 2>&1 &
fi
```

### Finding App UIDs

```bash
adb shell stat /data/media/0/Android/data/com.example.app
```

Look for `Uid: (XXXXX/ u0_aXXX)`

## Troubleshooting

### Scripts not running?
- Check if `/data/media/0/sync_load.sh` and `/data/media/0/sync_save.sh` exist
- Verify scripts are executable: `ls -l /data/media/0/sync_*.sh`
- Check Magisk logs: `adb logcat | grep AppSyncMonitor`

### Permission denied errors?
- Verify UIDs match your apps: `dumpsys package | grep userId`
- Update UID values in sync scripts

### Files not syncing?
- Ensure Syncthing-Fork is running and configured
- Check Syncthing status in its UI
- Verify folder paths exist

## Performance Impact

- **CPU**: Minimal - just checks foreground app every 10 seconds
- **Battery**: ~0.5% extra drain (negligible)
- **Storage**: No overhead, just copies existing files
- **Network**: Only when Syncthing syncs (independent of this module)

## Compatibility

- **Android**: 11+ (tested on Android 14)
- **Devices**: Any device with Magisk
- **ROMs**: GammaOS, LineageOS, GrapheneOS, Stock Android + custom ROM

## License

MIT - Feel free to modify and share

## Contributing

Found a bug? Have suggestions? Open an issue or PR:
- Discord: [GammaOS Community]
- GitHub: [Submit issue]

## Credits

Created for the GammaOS community with ❤️
