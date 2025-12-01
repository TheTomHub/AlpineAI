# 🍎 Native Swift/SwiftUI Setup

Build a native iOS app for Alpine AI using Swift and SwiftUI - optimized for M2 Mac.

## Why Native Swift?

- ⚡ **Faster performance** - Runs natively on M2
- 🎨 **Native UI** - Perfect iOS design
- 🔋 **Better battery life** - Optimized for Apple Silicon
- 🚀 **Smaller app size** - No JavaScript runtime

## Prerequisites

1. **Xcode 14+** (from App Store)
2. **macOS Ventura or later**
3. **M2 Mac** (you have this!)

## Setup Instructions

### Step 1: Create Xcode Project

1. Open **Xcode**
2. Click **Create a new Xcode project**
3. Choose **iOS → App**
4. Fill in:
   - **Product Name**: Alpine AI
   - **Team**: Your Apple ID (sign in if needed)
   - **Organization Identifier**: com.yourname
   - **Interface**: SwiftUI
   - **Language**: Swift
5. Choose save location: `AlpineAI/ios-native/AlpineAI`
6. Click **Create**

### Step 2: Add Source Files

Copy the provided Swift files to your project:

1. In Xcode, right-click on the **AlpineAI** folder
2. Select **Add Files to "AlpineAI"...**
3. Add these files:
   - `ContentView.swift` (replace existing)
   - `AlpineViewModel.swift`
   - `AlpineAIApp.swift` (replace existing)

### Step 3: Configure Network Access

1. In Xcode, select your project in the navigator
2. Select the **AlpineAI** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability**
5. Add **App Transport Security Settings**

Or edit `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

### Step 4: Update API URL (for Physical iPhone)

If testing on a **real iPhone**, edit `AlpineViewModel.swift`:

```swift
// Find this line:
private let baseURL = "http://localhost:8000"

// Change to your Mac's IP (find with: ifconfig | grep "inet ")
private let baseURL = "http://192.168.1.123:8000"
```

### Step 5: Run the App

1. Make sure your backend is running:
   ```bash
   cd AlpineAI
   source venv/bin/activate
   python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0
   ```

2. In Xcode:
   - Select **iPhone 15 Pro** (or any simulator) from the device menu
   - Click the **Play** button (or press `Cmd + R`)

The app will launch in the simulator!

## Running on Physical iPhone

### Step 1: Connect Your iPhone

1. Connect iPhone to your Mac with USB cable
2. Unlock your iPhone
3. Trust the computer if prompted

### Step 2: Select Device

1. In Xcode, click the device selector (top-left)
2. Select your iPhone from the list

### Step 3: Enable Developer Mode (First Time Only)

On iPhone:
1. Go to **Settings → Privacy & Security → Developer Mode**
2. Turn on **Developer Mode**
3. Restart your iPhone

### Step 4: Sign the App

1. In Xcode, select your project
2. Go to **Signing & Capabilities**
3. Select your **Team** (your Apple ID)
4. Xcode will automatically handle code signing

### Step 5: Build and Run

1. Click **Run** (or press `Cmd + R`)
2. App will install and launch on your iPhone!

**First time**: On your iPhone, go to **Settings → General → VPN & Device Management** and trust your developer certificate.

## Features

### Chat Interface
- Real-time messaging
- Auto-scrolling
- Message history
- Clear button
- Loading indicators

### Analysis View
- Text input with multi-line support
- Sentiment analysis
- Word and character count
- Results display

### Health Check
- Test backend connectivity
- View API status and version

## Project Structure

```
AlpineAI/
├── AlpineAIApp.swift       # App entry point
├── ContentView.swift        # Main UI
├── AlpineViewModel.swift    # Business logic & API calls
└── Info.plist              # App configuration
```

## Development Tips

### Live Preview

In Xcode, use **Canvas** to see live previews:
1. Open any `.swift` file
2. Press `Cmd + Option + Enter` to show Canvas
3. Click **Resume** to see live preview
4. Edit code and see changes in real-time!

### Debugging

1. Set breakpoints by clicking the line number gutter
2. Run with `Cmd + R`
3. Use the debug console at the bottom

### Hot Reload

SwiftUI supports live previews, but for device/simulator:
- Make changes to code
- Press `Cmd + R` to rebuild and run

## Customization

### Change Colors

Edit `ContentView.swift`:

```swift
.background(Color.blue)  // Change to any color
```

### Add Navigation

```swift
NavigationView {
    // Your views here
}
```

### Add More Screens

Create new SwiftUI Views:
1. File → New → File
2. Choose **SwiftUI View**
3. Name it (e.g., `SettingsView.swift`)

## Building for TestFlight/App Store

### Step 1: Archive

1. Select **Any iOS Device** from device menu
2. Product → Archive
3. Wait for build to complete

### Step 2: Upload

1. Click **Distribute App**
2. Choose **App Store Connect**
3. Follow the wizard

### Step 3: TestFlight

1. Go to https://appstoreconnect.apple.com
2. Select your app
3. Add to TestFlight
4. Invite testers

## Performance Optimization

### M2 Mac Advantages

Your M2 gives you:
- **Native ARM64** - No translation needed
- **Fast builds** - Compiled natively
- **Metal acceleration** - Smooth animations
- **Unified memory** - Better performance

### Tips

1. **Use Lazy Stacks** for long lists
2. **Avoid heavy computations** on main thread
3. **Use `Task` for async operations**
4. **Profile with Instruments** (Xcode → Product → Profile)

## Troubleshooting

### "No Signing Identity Found"

1. Xcode → Settings → Accounts
2. Add your Apple ID
3. Download Manual Profiles

### "Could not launch"

1. Delete app from simulator/device
2. Clean Build Folder: `Cmd + Shift + K`
3. Rebuild: `Cmd + B`

### Simulator is slow

1. Use iPhone 15 Pro simulator (best performance on M2)
2. Close other apps
3. Restart simulator

### Cannot connect to API

1. Check backend is running on `0.0.0.0`
2. For physical iPhone, use Mac's IP address
3. Check both devices on same WiFi

## Next Steps

1. ✅ Get app running on iPhone
2. 🎨 Customize UI colors and layout
3. 🔐 Add user authentication
4. 💾 Add local storage with UserDefaults
5. 🔔 Add push notifications
6. 🌙 Add dark mode support
7. 📱 Add iPad support

## Resources

- **SwiftUI Tutorials**: https://developer.apple.com/tutorials/swiftui
- **Swift Documentation**: https://swift.org/documentation/
- **WWDC Videos**: https://developer.apple.com/videos/

---

## Quick Start Command

Just follow these steps:

1. **Open Xcode** → Create new iOS App project
2. **Copy** the 3 Swift files to your project
3. **Run** with `Cmd + R`

That's it! Your native Swift app is running! 🚀
