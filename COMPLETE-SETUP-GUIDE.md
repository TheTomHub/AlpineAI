# 📱 Complete Alpine AI Setup - iPhone App Testing on M2 Mac

**Everything you need to test Alpine AI on your iPhone TODAY!**

This guide covers:
- ✅ Getting the code from Git
- ✅ Setting up the backend API
- ✅ Setting up the iPhone app (2 options!)
- ✅ Testing everything together

---

## 🎯 Overview

Alpine AI consists of:
1. **Backend API** (Python/FastAPI) - Runs on your Mac
2. **iPhone App** (React Native OR Native Swift) - Runs on your iPhone

**Time to test: 10-15 minutes** ⏱️

---

## Part 1: Get the Code from GitHub

### Step 1: Clone the Repository

```bash
# If you haven't cloned yet
git clone https://github.com/TheTomHub/AlpineAI.git
cd AlpineAI

# If you already cloned, pull the latest changes
cd AlpineAI
git pull origin claude/setup-alpine-m2-mac-0114V5UZCJxpC533VTm2zRS7
```

### Step 2: Checkout the Right Branch

```bash
git checkout claude/setup-alpine-m2-mac-0114V5UZCJxpC533VTm2zRS7
```

You should now see:
```
AlpineAI/
├── alpine/              # Backend API code
├── mobile-app/          # React Native app
├── ios-native/          # Native Swift app
├── scripts/             # Setup scripts
└── requirements.txt     # Python dependencies
```

---

## Part 2: Setup the Backend API

The backend must be running for the iPhone app to work!

### Step 1: Install Prerequisites

```bash
# Install Python 3.11 (if not installed)
brew install python@3.11

# Verify installation
python3 --version  # Should show 3.11 or higher
```

### Step 2: Run the Automated Setup

```bash
cd AlpineAI

# Run setup script (creates venv, installs dependencies)
bash scripts/setup.sh

# This will:
# - Create virtual environment
# - Install all Python packages
# - Create .env file
# - Setup data directories
```

### Step 3: Start the Backend Server

```bash
# Activate the virtual environment
source venv/bin/activate

# Start the server (IMPORTANT: use 0.0.0.0 to allow iPhone connection)
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0 --port 8000
```

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

### Step 4: Test the Backend

Open a **new terminal** (keep the server running) and test:

```bash
# Test health endpoint
curl http://localhost:8000/health

# You should see:
# {"status":"healthy","version":"0.1.0","environment":"development"}
```

✅ **Backend is ready!** Keep this terminal running.

---

## Part 3: Setup the iPhone App

You have **TWO OPTIONS**:
- **Option A**: React Native (faster to setup, works on iOS + Android)
- **Option B**: Native Swift (better performance, iOS only)

Choose one and follow the instructions below.

---

## Option A: React Native App (Recommended for Quick Testing)

### Prerequisites

```bash
# Install Node.js
brew install node

# Verify
node --version  # Should be v18 or higher
npm --version

# Install Expo CLI
npm install -g expo-cli

# Install Xcode from App Store (for simulator)
# After installing, open Xcode once to accept license
```

### Step 1: Setup the Mobile App

```bash
# Open a NEW terminal (Terminal #2)
cd AlpineAI/mobile-app/AlpineAI

# Install dependencies (this takes a few minutes)
npm install
```

### Step 2: Configure for Physical iPhone (Optional)

**Skip this if you're using the iOS Simulator**

If testing on a **real iPhone**:

1. Find your Mac's IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   # Look for something like: inet 192.168.1.123
   ```

2. Edit `App.js`:
   ```bash
   nano mobile-app/AlpineAI/App.js
   ```

3. Change line 17:
   ```javascript
   // FROM:
   const API_URL = 'http://localhost:8000';

   // TO (use your Mac's actual IP):
   const API_URL = 'http://192.168.1.123:8000';
   ```

4. Save and exit (Ctrl+X, then Y, then Enter)

### Step 3: Start the App

```bash
# In Terminal #2 (mobile-app/AlpineAI directory)
npm start
```

Expo will start and show you options:

```
› Press i │ open iOS simulator
› Press a │ open Android emulator
› Press w │ open web

› Press r │ reload app
› Press m │ toggle menu
```

### Step 4A: Run on iOS Simulator

```bash
# Press 'i' in the terminal
i
```

The iOS Simulator will open and load your app!

### Step 4B: Run on Physical iPhone

1. Install **Expo Go** from the App Store on your iPhone
2. Make sure your iPhone and Mac are on the **same WiFi network**
3. Open **Expo Go** on your iPhone
4. Scan the QR code shown in the terminal
5. The app will load on your iPhone!

---

## Option B: Native Swift App (Best Performance on M2)

### Prerequisites

```bash
# Install Xcode from App Store (if not installed)
# Open Xcode once to accept license agreement
xcode-select --install
```

### Step 1: Create Xcode Project

1. Open **Xcode**
2. Click **"Create a new Xcode project"**
3. Choose **iOS → App**
4. Settings:
   - **Product Name**: AlpineAI
   - **Team**: Your Apple ID (sign in if needed)
   - **Organization Identifier**: com.yourname.alpine
   - **Interface**: SwiftUI
   - **Language**: Swift
5. Save in: `AlpineAI/ios-native/AlpineAI`

### Step 2: Add Source Files

1. In Finder, go to: `AlpineAI/ios-native/AlpineAI/AlpineAI/`
2. You'll see 3 Swift files:
   - `AlpineAIApp.swift`
   - `ContentView.swift`
   - `AlpineViewModel.swift`

3. In Xcode:
   - Delete the default `ContentView.swift` and `AlpineAIApp.swift`
   - Drag the 3 files from Finder into your Xcode project

### Step 3: Configure Network Access

1. In Xcode, select your project (top of navigator)
2. Select the **AlpineAI** target
3. Go to **Info** tab
4. Right-click in the list → **Add Row**
5. Add:
   ```
   Key: App Transport Security Settings
   Type: Dictionary
   ```
6. Expand it, add sub-key:
   ```
   Key: Allow Arbitrary Loads in Web Content
   Value: YES (Boolean)
   ```

Or add to `Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

### Step 4: Configure for Physical iPhone (if needed)

If testing on real iPhone, edit `AlpineViewModel.swift`:

```swift
// Find line ~56:
private let baseURL = "http://localhost:8000"

// Change to your Mac's IP:
private let baseURL = "http://192.168.1.123:8000"
```

### Step 5: Run the App

**For Simulator:**
1. In Xcode, select **iPhone 15 Pro** from device menu (top-left)
2. Press **Play** button (or `Cmd + R`)

**For Physical iPhone:**
1. Connect iPhone with USB cable
2. Unlock iPhone and trust computer
3. In Xcode, select your iPhone from device menu
4. Press **Play** button (or `Cmd + R`)
5. On first run: iPhone Settings → General → VPN & Device Management → Trust developer

---

## Part 4: Test the Complete System

### Test 1: Health Check

In the iPhone app:
1. Tap **"Health Check"** button (top-right)
2. You should see: "✅ API Status: healthy"

**If this fails:**
- Backend not running? Check Terminal #1
- Wrong IP address? Update API_URL in the app
- Not on same WiFi? Connect both devices to same network

### Test 2: Chat Feature

1. Tap **💬 Chat** tab
2. Type: "Hello Alpine!"
3. Tap **Send**
4. You should see a response!

### Test 3: Analysis Feature

1. Tap **🔍 Analyze** tab
2. Enter text: "This is an amazing day!"
3. Tap **Analyze Sentiment**
4. You should see results:
   - Word count
   - Character count
   - Sentiment: positive
   - Confidence: 85%

---

## 🎉 Success!

You now have:
- ✅ Backend API running on your M2 Mac
- ✅ iPhone app connected to the API
- ✅ Full AI functionality working

---

## 🐛 Troubleshooting

### "Cannot connect to API"

**Problem**: Health check fails

**Solutions:**
1. Check backend is running (Terminal #1):
   ```bash
   curl http://localhost:8000/health
   ```
2. Verify backend is on 0.0.0.0 (not 127.0.0.1)
3. For physical iPhone:
   - Ensure same WiFi network
   - Use Mac's IP address in app (not localhost)
   - Find IP: `ifconfig | grep "inet "`

### "Port 8000 already in use"

```bash
# Find and kill process
lsof -ti:8000 | xargs kill -9

# Or use different port
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0 --port 8001
# (Update port in mobile app too!)
```

### React Native: "No bundle URL present"

```bash
# Clear cache and restart
cd mobile-app/AlpineAI
rm -rf node_modules
npm cache clean --force
npm install
npx expo start --clear
```

### Swift: "Signing requires a development team"

1. Xcode → Settings → Accounts
2. Add your Apple ID (free!)
3. In project settings → Signing & Capabilities
4. Select your team

### iOS Simulator won't open

```bash
# Open manually
open -a Simulator

# Or reset
xcrun simctl erase all
```

### Physical iPhone: "Untrusted Developer"

On iPhone:
1. Settings → General → VPN & Device Management
2. Find your developer profile
3. Tap **Trust**

---

## 📁 Project Structure

```
AlpineAI/
├── alpine/                    # Backend API
│   ├── api/main.py           # FastAPI endpoints
│   ├── models/               # AI models (add yours here)
│   └── config.py             # Configuration
│
├── mobile-app/AlpineAI/      # React Native app
│   ├── App.js                # Main app component
│   └── package.json          # Dependencies
│
├── ios-native/               # Native Swift app
│   └── AlpineAI/
│       └── AlpineAI/
│           ├── ContentView.swift      # UI
│           └── AlpineViewModel.swift  # Logic
│
├── scripts/
│   ├── setup.sh              # Automated setup
│   └── test.sh               # Test API
│
├── requirements.txt          # Python dependencies
├── docker-compose.yml        # Docker setup
└── README.md                 # Full documentation
```

---

## 🚀 Quick Commands Reference

### Backend
```bash
# Setup
bash scripts/setup.sh

# Start server
source venv/bin/activate
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0

# Test
curl http://localhost:8000/health
bash scripts/test.sh
```

### React Native App
```bash
cd mobile-app/AlpineAI
npm install
npm start
# Then press 'i' for iOS
```

### Swift App
```bash
# Open in Xcode
open ios-native/AlpineAI/AlpineAI.xcodeproj
# Then press Cmd+R to run
```

---

## 📚 Next Steps

1. **Customize the UI** - Edit colors, add your branding
2. **Add Features** - Voice input, image analysis, etc.
3. **Connect Real AI** - Add OpenAI/Anthropic API keys
4. **Add Authentication** - User accounts and login
5. **Deploy to Production** - Use Docker, deploy to cloud
6. **Publish to App Store** - Share with users!

---

## 📖 More Documentation

- **Backend README**: `README.md` - Full backend documentation
- **React Native Setup**: `mobile-app/SETUP.md` - Detailed mobile guide
- **Swift Setup**: `ios-native/SWIFT-SETUP.md` - Native iOS guide
- **Quick Start**: `QUICKSTART.md` - Minimal setup guide

---

## 🆘 Need Help?

Check the specific documentation files above for detailed troubleshooting and advanced configuration.

---

## ✅ Final Checklist

Before you start:
- [ ] Homebrew installed
- [ ] Python 3.11+ installed
- [ ] Node.js 18+ installed (for React Native)
- [ ] Xcode installed (from App Store)
- [ ] iPhone on same WiFi as Mac (for physical device)

To test:
- [ ] Clone/pull the repository
- [ ] Run `bash scripts/setup.sh`
- [ ] Start backend: `python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0`
- [ ] Test backend: `curl http://localhost:8000/health`
- [ ] Setup mobile app (React Native OR Swift)
- [ ] Run mobile app
- [ ] Test health check in app
- [ ] Test chat feature
- [ ] Test analysis feature

**You're ready to build amazing AI apps!** 🎉🏔️
