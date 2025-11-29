# Alpine MVP - Quick Start (5 Minutes)

**The fastest way to get Alpine running on your Mac.**

---

## Prerequisites

- macOS with Xcode 15.0+ installed
- Git installed
- ~10 minutes

---

## Option 1: Automated Setup (Recommended)

Copy and paste this into your terminal:

```bash
# 1. Clone repository
cd ~/Developer  # or wherever you keep projects
git clone https://github.com/TheTomHub/AlpineAI.git
cd AlpineAI

# 2. Checkout Alpine branch
git checkout claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA

# 3. Run automated setup
cd Alpine
chmod +x ../setup-alpine.sh
../setup-alpine.sh
```

The script will:
- ✅ Verify prerequisites
- ✅ Check source files
- ✅ Guide you through Xcode setup
- ✅ Open the project when ready

---

## Option 2: Manual Setup (If you prefer control)

### Step 1: Clone and checkout

```bash
cd ~/Developer
git clone https://github.com/TheTomHub/AlpineAI.git
cd AlpineAI
git checkout claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA
cd Alpine
```

### Step 2: Create Xcode project

```bash
open -a Xcode
```

**In Xcode:**
1. File → New → Project
2. iOS → App
3. Name: `Alpine`, Interface: `SwiftUI`, Language: `Swift`
4. Save in: `~/Developer/AlpineAI/Alpine/`
5. Delete `ContentView.swift`
6. Right-click Alpine → Add Files
7. Select all folders: `Models/`, `Services/`, `ViewModels/`, `Views/`
8. Check ✅ "Copy items if needed"
9. Project → Target → Signing & Capabilities → Add **Calendar**
10. Set deployment target: **iOS 17.0**

### Step 3: Build and run

```bash
# In Xcode:
# 1. Select iPhone 15 simulator
# 2. Press ⌘R
```

---

## Option 3: If you already have the repo

```bash
# Navigate to your existing clone
cd /path/to/AlpineAI

# Make sure you're on the right branch
git fetch origin
git checkout claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA
git pull

# Open in Xcode
cd Alpine
open Alpine.xcodeproj  # if project exists

# Or run setup script
chmod +x ../setup-alpine.sh
../setup-alpine.sh
```

---

## First Run Checklist

Once the app launches in the simulator:

### 1. Onboarding (30 seconds)
- [ ] Choose **Student** or **Professional** mode
- [ ] Tap **Begin**

### 2. Home Screen (1 minute)
- [ ] See greeting and AI Core widget
- [ ] Tap **"Enable Calendar Access"** in Today card
- [ ] Tap **"OK"** when permission dialog appears

### 3. Create Note (1 minute)
- [ ] Tap **Notes** tab
- [ ] Tap **+** button
- [ ] Type: "Testing Alpine MVP"
- [ ] Tap **Save**
- [ ] **AI Core levels up to Level 1!** 🎉

### 4. Test AI Console (2 minutes)
- [ ] Tap **Console** tab
- [ ] Type: "What's on my schedule today?"
- [ ] Get AI response
- [ ] Try: "What notes have I created?"
- [ ] **AI Core levels up to Level 4!** 🎉

### 5. Explore Settings (1 minute)
- [ ] Tap **Settings** tab
- [ ] See current level and usage stats
- [ ] Switch between Student ↔ Professional
- [ ] Go back to Home - see AI Core visual change!

---

## Troubleshooting

### "Repository not found"
```bash
# Use HTTPS URL
git clone https://github.com/TheTomHub/AlpineAI.git

# Or SSH (if you have keys set up)
git clone git@github.com:TheTomHub/AlpineAI.git
```

### "Branch not found"
```bash
# Fetch all branches first
git fetch origin
git branch -a  # List all branches
git checkout claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA
```

### "Build failed in Xcode"
```bash
# Clean build folder
# In Xcode: Product → Clean Build Folder (⇧⌘K)
# Then rebuild (⌘R)
```

### "Calendar permission not appearing"
```bash
# Reset simulator
# In Simulator: Device → Erase All Content and Settings
# Then rebuild app
```

### "Xcode won't open project"
```bash
# Verify project exists
ls -la Alpine.xcodeproj

# If missing, you need to create it (see Option 2)
```

---

## What's Next?

After testing the MVP:

1. **Read the docs:**
   - `README.md` - Full architecture
   - `SETUP_GUIDE.md` - Detailed setup
   - `PROJECT_STRUCTURE.md` - Code walkthrough

2. **Customize it:**
   - Change AI Core colors in `AICoreView.swift`
   - Modify responses in `StubAIEngine.swift`
   - Adjust UI in any View file

3. **Extend it:**
   - Add real AI (see TODOs in `StubAIEngine.swift`)
   - Integrate HealthKit (see README.md)
   - Add embeddings for semantic search

4. **Ship it:**
   - Add app icon
   - Test on physical device
   - Submit to TestFlight

---

## Quick Commands Reference

```bash
# Open project
cd ~/Developer/AlpineAI/Alpine && open Alpine.xcodeproj

# Pull latest changes
cd ~/Developer/AlpineAI
git pull origin claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA

# View project structure
cd ~/Developer/AlpineAI/Alpine
tree Alpine/  # or: find Alpine -name "*.swift"

# Run setup script again
./setup-alpine.sh
```

---

## Need Help?

- **Build errors?** See `SETUP_GUIDE.md` → Troubleshooting
- **Understanding code?** See `PROJECT_STRUCTURE.md`
- **Architecture questions?** See `README.md`

---

**🏔️ Enjoy building with Alpine! ✨**
