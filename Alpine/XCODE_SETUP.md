# Xcode Project Setup Guide

Since Xcode projects are complex binary files, follow these steps to create the Alpine project in Xcode:

## Method 1: Create New Project in Xcode (Recommended)

1. **Open Xcode** (version 15.0 or later)

2. **Create New Project:**
   - File → New → Project
   - Choose **iOS** → **App**
   - Click **Next**

3. **Configure Project:**
   - **Product Name:** `Alpine`
   - **Team:** Select your development team
   - **Organization Identifier:** `com.yourcompany` (or your preference)
   - **Interface:** `SwiftUI`
   - **Language:** `Swift`
   - **Storage:** None (we're using custom storage)
   - Uncheck "Include Tests" for now
   - Click **Next**

4. **Choose Location:**
   - Navigate to this `Alpine` directory
   - Click **Create**

5. **Delete Default Files:**
   - Delete the auto-generated `ContentView.swift`
   - Keep `AlpineApp.swift` (replace with our version)

6. **Add Our Files:**
   - Drag the entire `Alpine/` folder structure into the Xcode project navigator
   - Ensure "Copy items if needed" is **unchecked** (they're already in place)
   - Select "Create groups"
   - Add to target: Alpine

7. **Replace Info.plist:**
   - In Project Navigator, select the `Alpine` project (blue icon at top)
   - Select the `Alpine` target
   - Go to the **Info** tab
   - Click on `Info.plist` in the file list
   - Replace contents with our `Info.plist`

8. **Add Calendar Capability:**
   - Select project → Target → **Signing & Capabilities**
   - Click **+ Capability**
   - Add **Calendar** (it will add necessary entitlements)

9. **Configure Deployment Target:**
   - In General tab, set **Deployment Target** to `iOS 17.0`

10. **Build and Run:**
    - Select a simulator or device
    - Press ⌘R to build and run

---

## Method 2: Import Existing Files

If you already have the files in the Alpine directory:

1. **Create minimal Xcode project** as above

2. **Replace the entire Alpine folder contents** with our source files

3. **Refresh Xcode:**
   - File → Close Project
   - Reopen `Alpine.xcodeproj`

4. **Fix file references** if needed:
   - Right-click on any missing file
   - Show in Finder → re-add to project

---

## Project Structure in Xcode

Your project navigator should look like this:

```
Alpine (project)
└── Alpine (folder)
    ├── AlpineApp.swift
    ├── Models/
    │   ├── AICoreMode.swift
    │   ├── AICoreLevel.swift
    │   ├── AICoreState.swift
    │   ├── EventSummary.swift
    │   └── Note.swift
    ├── Services/
    │   ├── AIEngine.swift
    │   ├── StubAIEngine.swift
    │   ├── CalendarService.swift
    │   ├── NotesStore.swift
    │   └── AICoreProgressService.swift
    ├── ViewModels/
    │   ├── AppState.swift
    │   ├── HomeDashboardViewModel.swift
    │   ├── ConsoleViewModel.swift
    │   └── SettingsViewModel.swift
    ├── Views/
    │   ├── Onboarding/
    │   │   └── OnboardingView.swift
    │   ├── Home/
    │   │   ├── HomeDashboardView.swift
    │   │   ├── AICoreWidgetView.swift
    │   │   ├── TodayCardView.swift
    │   │   └── NotesCardView.swift
    │   ├── Console/
    │   │   └── ConsoleView.swift
    │   ├── Settings/
    │   │   └── SettingsView.swift
    │   └── Components/
    │       └── AICoreView.swift
    └── Info.plist
```

---

## Troubleshooting

### Build Errors

**Missing imports:**
- Ensure deployment target is iOS 17.0+
- Verify all files are added to the Alpine target (check file inspector)

**Calendar not working:**
- Check Info.plist has `NSCalendarsUsageDescription`
- Verify Calendar capability is added in Signing & Capabilities
- On simulator, go to Settings → Privacy → Calendars → Alpine → enable

**Dark mode not applying:**
- The app forces dark mode in `AlpineApp.swift` with `.preferredColorScheme(.dark)`
- This is intentional for the LCARS aesthetic

### Runtime Issues

**"App wants to access your calendar":**
- This is expected! Tap "Allow" to enable calendar integration

**AI Core not leveling up:**
- Check console logs for progression triggers
- Open Settings → view usage stats
- The progression is working if you see stats incrementing

**Notes not persisting:**
- Check UserDefaults is enabled (it should be by default)
- For production, migrate to CoreData

---

## Next Steps

1. **Test on Device:**
   - Connect iPhone via USB
   - Trust computer on device
   - Select device in Xcode
   - Build and run

2. **Add App Icon:**
   - Design 1024x1024 icon
   - Add to Assets.xcassets/AppIcon

3. **Customize Bundle ID:**
   - Project → Target → General
   - Change Bundle Identifier to your own

4. **Enable Developer Mode** (iOS 16+):
   - Settings → Privacy & Security → Developer Mode → On

---

## Build Settings Reference

**Minimum Configuration:**
- Platform: iOS
- Deployment Target: 17.0
- Swift Version: 5.9
- Build System: New Build System

**Signing:**
- Automatically manage signing: ✓
- Team: [Your Team]
- Bundle ID: com.yourcompany.Alpine

**Capabilities:**
- Calendar ✓
- (Future) HealthKit
- (Future) Siri

---

## Testing Checklist

After setup, verify:
- [ ] App launches without crashes
- [ ] Onboarding flow works
- [ ] Can select Student/Professional mode
- [ ] Home dashboard renders
- [ ] Calendar permission request appears
- [ ] Can create notes
- [ ] Console accepts questions
- [ ] AI Core visual animates
- [ ] Settings show correct data
- [ ] Dark mode is enforced

---

## Advanced Configuration

### Custom Schemes

Create schemes for different configurations:
- **Alpine Dev** – with debug logging
- **Alpine Production** – optimized builds

### Build Configurations

Add preprocessor flags for feature flags:
```swift
#if DEBUG
let enableHealthKit = false
#else
let enableHealthKit = true
#endif
```

### Continuous Integration

For CI/CD (GitHub Actions, etc.):
```yaml
- name: Build Alpine
  run: |
    xcodebuild -scheme Alpine \
      -sdk iphonesimulator \
      -destination 'platform=iOS Simulator,name=iPhone 15' \
      build
```

---

Need help? Check the main README.md or open an issue!
