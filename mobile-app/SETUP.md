# 📱 Alpine AI - iPhone App Setup Guide

Complete setup instructions for testing the Alpine AI iPhone app on your M2 Mac.

## 🎯 What You'll Get

A fully functional iPhone app with:
- 💬 **Chat Interface** - Talk to Alpine AI
- 🔍 **Text Analysis** - Analyze sentiment and more
- ✅ **Health Check** - Monitor backend status
- 🎨 **Beautiful UI** - Native iOS design

## 📋 Prerequisites

### 1. Install Node.js
```bash
# Using Homebrew on M2 Mac
brew install node

# Verify installation
node --version  # Should be v18 or higher
npm --version
```

### 2. Install Xcode (for iOS Simulator)
1. Open **App Store**
2. Search for **Xcode**
3. Download and install (this takes a while, it's ~12GB)
4. Open Xcode once to accept the license agreement

### 3. Install Xcode Command Line Tools
```bash
xcode-select --install
```

### 4. Install Expo CLI
```bash
npm install -g expo-cli
```

### 5. Install Expo Go on Your iPhone (Optional)
- Open **App Store** on your iPhone
- Search for **Expo Go**
- Install the app

## 🚀 Quick Start - Test on iPhone TODAY!

### Step 1: Start the Backend API

Open Terminal #1:
```bash
cd AlpineAI

# If not already set up
bash scripts/setup.sh
source venv/bin/activate

# Start the API
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0
```

The API should now be running on http://localhost:8000

### Step 2: Setup the Mobile App

Open Terminal #2:
```bash
cd AlpineAI/mobile-app/AlpineAI

# Install dependencies
npm install

# Start Expo
npm start
```

### Step 3: Run on iPhone Simulator

When Expo starts, press:
- Press **`i`** for iOS simulator

The iOS simulator will open and load your app!

### Step 4: Run on Physical iPhone

**Option A: Using Expo Go (Easiest)**
1. Make sure your iPhone and Mac are on the **same WiFi network**
2. Open **Expo Go** app on your iPhone
3. Scan the QR code from the terminal
4. The app will load!

**Option B: Using Expo Dev Client**
```bash
# In the mobile-app/AlpineAI directory
npx expo run:ios
```

## ⚙️ Configuration for Physical iPhone

If testing on a **real iPhone** (not simulator), you need to update the API URL:

### Find Your Mac's IP Address
```bash
# Get your Mac's local IP
ifconfig | grep "inet " | grep -v 127.0.0.1
```

You'll see something like: `inet 192.168.1.123`

### Update App.js

Edit `mobile-app/AlpineAI/App.js` and change line 17:

```javascript
// FROM:
const API_URL = 'http://localhost:8000';

// TO (use your Mac's IP):
const API_URL = 'http://192.168.1.123:8000';
```

Save and the app will reload automatically!

## 🧪 Testing the App

### 1. Health Check
- Tap **"Health Check"** button in the top-right
- You should see: "✅ API Status: healthy"

### 2. Chat Tab
- Type a message: "Hello Alpine!"
- Tap **Send**
- You'll see the AI response

### 3. Analyze Tab
- Switch to **🔍 Analyze** tab
- Enter some text: "This is an amazing day!"
- Tap **Analyze Sentiment**
- See the sentiment analysis results

## 📱 App Features

### Chat Interface
- Real-time messaging with Alpine AI
- Message history
- Clear button to reset conversation
- Loading indicators
- Error handling

### Text Analysis
- Sentiment analysis
- Word and character count
- Confidence scores
- Clean, card-based results

## 🐛 Troubleshooting

### "Cannot connect to API"

**Problem**: App can't reach the backend

**Solutions**:
1. Make sure backend is running (check Terminal #1)
2. Visit http://localhost:8000/health in your browser
3. If using physical iPhone:
   - Ensure iPhone and Mac are on same WiFi
   - Update API_URL with your Mac's IP address
   - Make sure backend is listening on 0.0.0.0 (not just 127.0.0.1)

### Backend not accessible from iPhone

If the backend works in browser but not on iPhone:

```bash
# Stop the backend and restart with:
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0 --port 8000
```

The `--host 0.0.0.0` is critical for network access!

### "No connected devices"

```bash
# Check iOS simulator is installed
xcrun simctl list devices

# Open simulator manually
open -a Simulator
```

### Expo won't start

```bash
# Clear cache and reinstall
cd mobile-app/AlpineAI
rm -rf node_modules
npm cache clean --force
npm install
```

### Metro bundler issues

```bash
# In the mobile app directory
npx expo start --clear
```

## 🎨 Customization

### Change App Colors

Edit `App.js` and modify the `styles` object:

```javascript
header: {
  backgroundColor: '#007AFF', // Change this!
  // ...
},
```

### Add App Icons

1. Generate icons at https://www.appicon.co/
2. Download the pack
3. Place in `mobile-app/AlpineAI/assets/`:
   - `icon.png` (1024x1024)
   - `splash.png` (1284x2778)
   - `adaptive-icon.png` (1024x1024)

### Modify API Endpoints

Edit `App.js` and update the functions:
- `sendMessage()` - Chat endpoint
- `analyzeText()` - Analysis endpoint
- `checkHealth()` - Health check

## 📦 Building for Production

### Build Standalone App

```bash
# Install EAS CLI
npm install -g eas-cli

# Login to Expo
eas login

# Configure the project
eas build:configure

# Build for iOS
eas build --platform ios
```

### Submit to App Store

```bash
eas submit --platform ios
```

## 🔧 Development Tips

### Hot Reload
- Edit `App.js` and save
- The app automatically reloads on your device!

### Debug Menu
- **iOS Simulator**: Press `Cmd + D`
- **Physical iPhone**: Shake the device

### View Logs
```bash
# In the mobile app directory
npx expo start

# Then press 'j' to open debugger
```

## 📂 Project Structure

```
mobile-app/AlpineAI/
├── App.js              # Main app component
├── app.json            # Expo configuration
├── package.json        # Dependencies
├── babel.config.js     # Babel configuration
└── assets/             # App icons and images
    ├── icon.png
    ├── splash.png
    └── adaptive-icon.png
```

## 🚀 Quick Commands Reference

```bash
# Install dependencies
npm install

# Start Expo
npm start

# Run on iOS Simulator
npm run ios

# Run on Android
npm run android

# Clear cache
npx expo start --clear

# Check for issues
npx expo doctor
```

## 📚 Next Steps

1. ✅ Get the app running on your iPhone
2. 🎨 Customize the UI to match your brand
3. 🔌 Add more API endpoints
4. 📱 Add navigation for multiple screens
5. 💾 Add local storage with AsyncStorage
6. 🔔 Add push notifications
7. 📊 Add analytics

## 💡 Tips for M2 Mac

Your M2 Mac has advantages:
- **Fast builds** - Native ARM architecture
- **iOS Simulator runs natively** - Better performance
- **Metal acceleration** - Smooth animations

## 🆘 Need Help?

1. **Expo Documentation**: https://docs.expo.dev
2. **React Native Docs**: https://reactnative.dev
3. **Expo Forums**: https://forums.expo.dev

---

## 🎉 You're Ready!

Run these commands in order:

```bash
# Terminal 1: Start Backend
cd AlpineAI
source venv/bin/activate
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0

# Terminal 2: Start Mobile App
cd AlpineAI/mobile-app/AlpineAI
npm install
npm start

# Then press 'i' for iOS simulator!
```

**Your Alpine AI app will be running on iPhone in under 5 minutes!** 📱✨
