# 📋 AppSyncMonitor - Project Index

**Last Updated:** May 17, 2026
**Project Status:** ✅ Ready for GammaOS submission

---

## 🎯 Project Overview

**Name:** App Sync Monitor - Magisk Module for GammaOS  
**Purpose:** Automatically sync emulator saves between phone and Syncthing  
**Target Apps:** NetherSX2, Dolphin, and other emulators  
**Status:** Complete and tested  

---

## 📁 Repository Structure

```
AppSyncMonitor/
├── README.md              ← Main documentation (user-friendly)
├── module.prop            ← Module metadata
├── service.sh             ← Main monitoring script
├── post-fs-data.sh        ← Magisk hook (required)
├── .gitignore             ← Git configuration
├── INDEX.md               ← This file (project reference)
└── docs/
    └── (future documentation)
```

---

## 📋 Files Reference

### `README.md`
- **Status:** ✅ Complete and polished
- **Content:** User guide with emojis, tables, FAQ
- **Style:** Beginner-friendly, visual
- **Last Update:** May 17, 2026

### `module.prop`
- **Status:** ✅ Complete
- **Content:** Module metadata (id, name, version, author, description)
- **Key Fields:** 
  - `id=app_sync_monitor`
  - `version=1.0`

### `service.sh`
- **Status:** ✅ Complete
- **Content:** Main monitoring script (monitors app launches/closes)
- **Logic:** Detects when NetherSX2/Dolphin open/close
- **Interval:** Checks every 10 seconds for battery efficiency

### `post-fs-data.sh`
- **Status:** ✅ Complete
- **Content:** Empty Magisk hook (required by Magisk)

### `.gitignore`
- **Status:** ✅ Complete
- **Ignores:** .DS_Store, *.zip, temporary files

---

## 🎨 Style Guide

**When editing README or documentation:**
- ✅ Use emojis for visual interest (🎮 🚀 ⚡)
- ✅ Use numbered sections (1️⃣ 2️⃣ 3️⃣)
- ✅ Use tables for comparisons
- ✅ Use clear ### headers and hierarchy
- ✅ Include FAQ section
- ✅ Add Performance & Compatibility sections
- ✅ Keep tone friendly, casual, beginner-friendly
- ✅ Explain technical terms simply

**See README.md for example of this style**

---

## 🔄 Workflow for Updates

### When making changes:

1. **Edit locally** in your repo folder
2. **Test the change** (read through it)
3. **Commit with clear message:**
   ```bash
   git add .
   git commit -m "Update README with [what changed]"
   git push origin main
   ```

### When asking for help:

Include:
- What you want to change
- The section/file name
- Reference this INDEX.md
- Mention style preference (or use default README style)

---

## 📝 Known Issues / TODO

- [ ] Test module on actual GammaOS device (already done ✅)
- [ ] Create ZIP package for Magisk installation
- [ ] Submit to GammaOS discussions
- [ ] Add more language support (future)
- [ ] Create video tutorial (future)

---

## 🚀 Submission Status

### For GammaOS:
- ✅ Module code complete and tested
- ✅ README with full documentation
- ✅ Beginner-friendly instructions
- ✅ Troubleshooting section included
- ⏳ Ready to submit to: https://github.com/TheGammaSqueeze/GammaOSNext/discussions/330

### GitHub Repo:
- ✅ Repository created
- ✅ Files pushed to main branch
- ✅ README complete with emojis/style
- ⏳ Waiting: ZIP package creation

---

## 🔗 Key Links

| Link | Purpose |
|------|---------|
| https://github.com/Mikasway/AppSyncMonitor | Project repo |
| https://developer.android.com/tools/releases/platform-tools | ADB download |
| https://github.com/TheGammaSqueeze/GammaOSNext/discussions/330 | GammaOS submission thread |

---

## 📞 Communication Notes

**When working on this project together:**

1. Reference this INDEX.md for quick lookup
2. Mention file names when discussing changes
3. Use the style guide above for consistency
4. Keep README user-friendly (not too technical)
5. Test changes locally before pushing

---

## 🎓 Quick Reference

**App UIDs:**
- NetherSX2: `u0_a190`
- Dolphin: `u0_a181`

**Script Paths:**
- Load script: `/data/media/0/sync_load.sh`
- Save script: `/data/media/0/sync_save.sh`

**Syncthing Folders:**
- NetherSX2: `~/Android/data/xyz.aethersx2.android/files`
- Dolphin: `~/Android/data/org.dolphinemu.dolphinemu/files`

---

## 📄 License

MIT - Free to use, modify, and distribute

---

**Made for GammaOS community ❤️**
