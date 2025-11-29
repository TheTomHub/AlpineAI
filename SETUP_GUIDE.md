# Alpine MVP - Local Setup Guide

Complete step-by-step guide to run Alpine on your Mac.

---

## Prerequisites Check

Run these commands to verify you have the required tools:

```bash
# Check Xcode installation
xcodebuild -version
# Should show: Xcode 15.0 or later

# Check Swift version
swift --version
# Should show: Swift 5.9 or later

# Check git
git --version
```

If any are missing:
- **Xcode**: Download from Mac App Store
- **Command Line Tools**: `xcode-select --install`

---

## Step 1: Clone the Repository

```bash
# Navigate to where you want the project
cd ~/Developer  # or your preferred directory

# Clone the repository
git clone https://github.com/TheTomHub/AlpineAI.git

# Enter the project directory
cd AlpineAI

# Switch to the Alpine MVP branch
git checkout claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA

# Verify files are present
ls -la Alpine/Alpine/
```

You should see the Alpine directory with all source files.

---

## Step 2: Create Xcode Project

Since Xcode project files are binary, we'll create one:

```bash
# Navigate to the Alpine directory
cd Alpine

# We'll create the Xcode project via Xcode GUI
# But first, let's verify the structure
tree -L 3 .
# or
find . -type f -name "*.swift" | head -20
```

Now open Xcode to create the project:

```bash
# Open Xcode
open -a Xcode
```

---

## Step 3: Set Up Project in Xcode

**In Xcode:**

1. **Create New Project**
   - File → New → Project (⇧⌘N)
   - Select: **iOS** → **App**
   - Click **Next**

2. **Configure Project**
   - Product Name: `Alpine`
   - Team: Select your Apple ID
   - Organization Identifier: `com.yourname` (or anything)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - ✅ Use Xcode Cloud: **NO**
   - ✅ Include Tests: **NO** (optional)
   - Click **Next**

3. **Save Location**
   - Navigate to: `~/Developer/AlpineAI/Alpine/` (the directory we cloned)
   - **IMPORTANT**: Save INSIDE the `Alpine` folder
   - Click **Create**

4. **Delete Default Files**
   - In Project Navigator, delete:
     - `ContentView.swift` (Move to Trash)
   - Keep: `AlpineApp.swift`

5. **Add Our Source Files**
   - Right-click on `Alpine` folder (blue icon)
   - Select **Add Files to "Alpine"...**
   - Navigate to the `Alpine/Alpine/` directory
   - Select ALL Swift files and folders:
     - Models/
     - Services/
     - ViewModels/
     - Views/
     - Info.plist (if not already included)
   - **IMPORTANT**: ✅ Check "Copy items if needed"
   - **IMPORTANT**: ✅ Check "Create groups"
   - **IMPORTANT**: ✅ Check "Alpine" target
   - Click **Add**

6. **Configure Info.plist**
   - Select the **Alpine** project (blue icon at top)
   - Select the **Alpine** target
   - Go to **Info** tab
   - Right-click in the list → **Open As** → **Source Code**
   - Replace contents with our `Info.plist` file
   - Or manually add:
     - `NSCalendarsUsageDescription`: "Alpine needs access to your calendar to provide insights about your schedule and upcoming events."
     - `NSCalendarsFullAccessUsageDescription`: "Alpine needs full calendar access to read your events and provide intelligent scheduling insights."

7. **Add Calendar Capability**
   - Select project → Target → **Signing & Capabilities**
   - Click **+ Capability**
   - Search for and add: **Calendar**

8. **Set Deployment Target**
   - In **General** tab
   - Set **iOS Deployment Target**: **17.0**

---

## Step 4: Alternative - Use Script to Create Project

If you prefer terminal automation, create a basic Package.swift:

```bash
cd ~/Developer/AlpineAI/Alpine/

# Create a Swift package (temporary structure)
cat > Package.swift << 'EOF'
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Alpine",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Alpine", targets: ["Alpine"])
    ],
    targets: [
        .target(name: "Alpine", path: "Alpine")
    ]
)
EOF

# Verify it compiles (won't run, just checks syntax)
swift build
```

**Note**: This won't create a runnable iOS app, but validates the code. For actual iOS app, use Xcode method above.

---

## Step 5: Build and Run

### Option A: Using Xcode GUI (Recommended)

```bash
# Open the project
cd ~/Developer/AlpineAI/Alpine/
open Alpine.xcodeproj
```

**In Xcode:**
1. Select a simulator: iPhone 15 (or any iPhone)
2. Press **⌘R** or click ▶️ Play button
3. Wait for build...
4. App launches in simulator!

### Option B: Using Terminal (Command Line)

```bash
cd ~/Developer/AlpineAI/Alpine/

# List available simulators
xcrun simctl list devices available | grep iPhone

# Build and run on iPhone 15 simulator
xcodebuild -scheme Alpine \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  build

# Launch the simulator
open -a Simulator

# Install and run (after successful build)
# Note: You'll need to find the .app bundle and install it
```

**Simpler terminal command:**

```bash
# Build and run in one command
xcodebuild -scheme Alpine \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -derivedDataPath ./build \
  build

# Then manually drag the .app to simulator
# Or use xcrun simctl install
```

---

## Step 6: Test the MVP

Once the app launches:

### First Launch - Onboarding
1. You'll see the **Alpine** splash with mode selection
2. Choose **Student** or **Professional** mode
3. Tap **Begin**

### Home Dashboard
1. You'll see greeting (Good morning/afternoon/evening)
2. **AI Core widget** shows Level 0 (Dormant)
3. **Today** card asks for calendar access
   - Tap **"Enable Calendar Access"**
   - Simulator will show permission dialog
   - Tap **"Allow"** (or "OK")
4. If you have events in simulator calendar, they'll appear
5. **Notes** card shows empty state

### Create a Note
1. Tap **Notes** tab at bottom
2. Tap **+** button (top right)
3. Type anything: "Testing Alpine MVP"
4. Tap **Save**
5. Note appears in list
6. Go back to **Home** tab
7. Note now shows in **Recent Notes** card
8. **AI Core** should level up to **Level 1 - Spark** 🎉

### Test AI Console
1. Tap **Console** tab
2. Type: "What's on my schedule today?"
3. Tap send (paper plane icon)
4. AI responds with calendar summary
5. Try: "What notes have I created?"
6. AI shows your notes
7. **AI Core** levels up to **Level 4 - Contextual** 🎉

### Check Settings
1. Tap **Settings** tab
2. See current mode, level, usage stats
3. Try switching Student ↔ Professional
4. Go back to **Home** - AI Core visual changes!

### Add Calendar Events (in Simulator)
```bash
# Open Calendar app in simulator
# Or add events manually in iOS Calendar app
```

---

## Step 7: Troubleshooting

### Build Errors

**Error: "Missing required modules"**
```bash
# Clean build folder
cd ~/Developer/AlpineAI/Alpine/
rm -rf ~/Library/Developer/Xcode/DerivedData/Alpine-*

# In Xcode: Product → Clean Build Folder (⇧⌘K)
# Then rebuild
```

**Error: "No such module 'EventKit'"**
- Check deployment target is iOS 17.0+
- Verify all files are added to Alpine target

**Error: "Multiple commands produce AlpineApp.swift"**
- Remove duplicate file references in Xcode
- Check only ONE AlpineApp.swift exists

### Runtime Errors

**Calendar permission not showing:**
- Check Info.plist has `NSCalendarsUsageDescription`
- Delete app from simulator and reinstall
- Reset simulator: Device → Erase All Content and Settings

**App crashes on launch:**
- Check console for errors (⌘Y to show Debug area)
- Verify all files are compiled (check Compile Sources in Build Phases)

**AI Core not animating:**
- This is normal on slower simulators
- Try on a physical device for smooth animations

### Simulator Issues

**Can't find iPhone 15:**
```bash
# List all available simulators
xcrun simctl list devices

# Create iPhone 15 simulator if needed
xcrun simctl create "iPhone 15" "iPhone 15"
```

**Simulator is slow:**
```bash
# Use iPhone SE (3rd gen) instead - faster
# Or increase simulator resources in Xcode Preferences
```

---

## Step 8: Test on Physical Device

### Requirements
- iPhone with iOS 17.0+
- Lightning/USB-C cable
- Apple ID enrolled in free developer program

### Steps

1. **Connect iPhone**
   ```bash
   # Check device is recognized
   xcrun xctrace list devices
   ```

2. **Trust Computer** (on iPhone)
   - Unlock iPhone
   - Tap "Trust" when prompted

3. **Select Device in Xcode**
   - Top toolbar: Change from simulator to your iPhone
   - Example: "Tom's iPhone"

4. **Enable Developer Mode** (iOS 16+)
   - On iPhone: Settings → Privacy & Security → Developer Mode → ON
   - Restart iPhone

5. **Build and Run**
   - Press ⌘R in Xcode
   - First time: May need to verify developer in iPhone Settings
   - Settings → General → VPN & Device Management → Trust developer

6. **Grant Permissions**
   - App will request Calendar access
   - Tap "Allow"

---

## Step 9: Verify Everything Works

### Checklist

- [ ] App launches without crashes
- [ ] Onboarding shows both modes with AI Core preview
- [ ] Can select Student or Professional mode
- [ ] Home dashboard renders with cards
- [ ] Calendar permission request appears
- [ ] Can grant calendar access
- [ ] Events appear in Today card (if you have any)
- [ ] Can create notes
- [ ] Notes appear in Recent Notes card
- [ ] Console accepts questions
- [ ] AI responds with contextual answers
- [ ] AI Core widget shows current level
- [ ] AI Core visual animates (pulse, rotation)
- [ ] Can switch modes in Settings
- [ ] AI Core visual changes with mode
- [ ] Usage stats update in Settings
- [ ] Can reset AI Core
- [ ] Dark mode is enforced

---

## Step 10: Development Workflow

### Make Changes

```bash
# Create a new branch for your changes
cd ~/Developer/AlpineAI/
git checkout -b feature/my-changes

# Make edits in Xcode
# Save files

# Test changes
# Build and run (⌘R)

# Commit changes
git add .
git commit -m "Add my feature"
git push origin feature/my-changes
```

### Hot Reload (SwiftUI Preview)

In any View file:
1. Open the file (e.g., `HomeDashboardView.swift`)
2. Click **Resume** button in preview panel (right side)
3. Or press ⌥⌘P
4. Make changes → Preview updates live!

### Debug

```bash
# View console logs
# In Xcode: View → Debug Area → Show Debug Area (⌘Y)

# Add breakpoints
# Click line number gutter in Xcode

# Print debug info
# Add: print("Debug: \(variable)")
```

---

## Quick Reference

### Essential Commands

```bash
# Open project
cd ~/Developer/AlpineAI/Alpine/ && open Alpine.xcodeproj

# Clean build
rm -rf ~/Library/Developer/Xcode/DerivedData/Alpine-*

# List simulators
xcrun simctl list devices available | grep iPhone

# Reset simulator
xcrun simctl erase all

# View git status
cd ~/Developer/AlpineAI/ && git status

# Pull latest changes
git pull origin claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA
```

### Keyboard Shortcuts (Xcode)

- `⌘R` - Build and Run
- `⌘B` - Build only
- `⌘.` - Stop
- `⇧⌘K` - Clean Build Folder
- `⌘Y` - Toggle Debug Area
- `⌘0` - Show/Hide Navigator
- `⌥⌘P` - Resume SwiftUI Preview

---

## Next Steps

1. **Explore the code** - Start with `AlpineApp.swift`
2. **Customize visuals** - Edit `AICoreView.swift`
3. **Add features** - Follow TODOs in code
4. **Integrate CoreML** - See README.md for guide
5. **Add HealthKit** - See README.md for instructions

---

Need help? Check:
- `README.md` - Architecture overview
- `PROJECT_STRUCTURE.md` - File breakdown
- `XCODE_SETUP.md` - Detailed Xcode config

Happy coding! 🏔️✨
