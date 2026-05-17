#!/system/bin/sh
# App Sync Monitor - Service Script
# Monitors app launches and closures, triggering sync scripts automatically

NETHER_PKG="xyz.aethersx2.android"
DOLPHIN_PKG="org.dolphinemu.dolphinemu"
NETHER_RUNNING=0
DOLPHIN_RUNNING=0

# Path to sync scripts (customize as needed)
SYNC_LOAD_SCRIPT="/data/media/0/sync_load.sh"
SYNC_SAVE_SCRIPT="/data/media/0/sync_save.sh"

# Check if scripts exist
if [ ! -f "$SYNC_LOAD_SCRIPT" ] || [ ! -f "$SYNC_SAVE_SCRIPT" ]; then
  exit 1
fi

while true; do
  # Get the foreground app package name
  FOREGROUND=$(dumpsys window windows 2>/dev/null | grep -m1 "mCurrentFocus" | grep -oE "[a-z0-9._]+" | tail -1)

  # Monitor NetherSX2
  if [ "$FOREGROUND" = "$NETHER_PKG" ] && [ $NETHER_RUNNING -eq 0 ]; then
    NETHER_RUNNING=1
    "$SYNC_LOAD_SCRIPT" > /dev/null 2>&1 &
  elif [ "$FOREGROUND" != "$NETHER_PKG" ] && [ $NETHER_RUNNING -eq 1 ]; then
    NETHER_RUNNING=0
    "$SYNC_SAVE_SCRIPT" > /dev/null 2>&1 &
  fi

  # Monitor Dolphin
  if [ "$FOREGROUND" = "$DOLPHIN_PKG" ] && [ $DOLPHIN_RUNNING -eq 0 ]; then
    DOLPHIN_RUNNING=1
    "$SYNC_LOAD_SCRIPT" > /dev/null 2>&1 &
  elif [ "$FOREGROUND" != "$DOLPHIN_PKG" ] && [ $DOLPHIN_RUNNING -eq 1 ]; then
    DOLPHIN_RUNNING=0
    "$SYNC_SAVE_SCRIPT" > /dev/null 2>&1 &
  fi

  # Check every 10 seconds for battery efficiency
  sleep 10
done
