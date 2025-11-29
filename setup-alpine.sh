#!/bin/bash

# Alpine MVP - Automated Setup Script
# This script will guide you through setting up Alpine on your Mac

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Banner
echo -e "${BLUE}"
cat << "EOF"
    ___    __      _
   /   |  / /___  (_)___  ___
  / /| | / / __ \/ / __ \/ _ \
 / ___ |/ / /_/ / / / / /  __/
/_/  |_/_/ .___/_/_/ /_/\___/
        /_/

Alpine AI Console - MVP Setup
EOF
echo -e "${NC}"

# Step 1: Check Prerequisites
print_header "Step 1: Checking Prerequisites"

echo -n "Checking Xcode installation... "
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo -e "${GREEN}✓${NC} $XCODE_VERSION"
else
    print_error "Xcode not found!"
    echo "Please install Xcode from the Mac App Store"
    echo "Then run: xcode-select --install"
    exit 1
fi

echo -n "Checking Swift installation... "
if command -v swift &> /dev/null; then
    SWIFT_VERSION=$(swift --version | head -n 1)
    echo -e "${GREEN}✓${NC} $SWIFT_VERSION"
else
    print_error "Swift not found!"
    exit 1
fi

echo -n "Checking Git installation... "
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✓${NC} $GIT_VERSION"
else
    print_error "Git not found!"
    exit 1
fi

print_step "All prerequisites met!"

# Step 2: Determine if we're already in the repo or need to clone
print_header "Step 2: Repository Setup"

CURRENT_DIR=$(pwd)
REPO_NAME="AlpineAI"

if [ -d ".git" ] && [ -f "Alpine/README.md" ]; then
    print_info "Already inside AlpineAI repository"
    REPO_DIR=$CURRENT_DIR
else
    print_info "Need to clone repository"

    # Ask for clone location
    echo -n "Where should we clone the repository? (default: ~/Developer): "
    read CLONE_DIR
    CLONE_DIR=${CLONE_DIR:-~/Developer}
    CLONE_DIR="${CLONE_DIR/#\~/$HOME}"  # Expand ~

    # Create directory if it doesn't exist
    mkdir -p "$CLONE_DIR"
    cd "$CLONE_DIR"

    # Clone repository
    print_info "Cloning AlpineAI repository..."

    if [ -d "$REPO_NAME" ]; then
        print_info "Directory $REPO_NAME already exists, entering it..."
        cd "$REPO_NAME"
    else
        echo -n "Enter repository URL (or press Enter for default): "
        read REPO_URL
        REPO_URL=${REPO_URL:-https://github.com/TheTomHub/AlpineAI.git}

        git clone "$REPO_URL"
        cd "$REPO_NAME"
    fi

    REPO_DIR=$(pwd)
fi

print_step "Repository ready at: $REPO_DIR"

# Step 3: Checkout the Alpine MVP branch
print_header "Step 3: Checking out Alpine MVP branch"

BRANCH="claude/alpine-ai-console-mvp-01SHg59uKmhG6FYX5aobbFmA"

echo "Fetching latest changes..."
git fetch origin

echo "Checking out branch: $BRANCH"
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"

git pull origin "$BRANCH" 2>/dev/null || true

print_step "On branch: $(git branch --show-current)"

# Step 4: Verify Alpine source files
print_header "Step 4: Verifying Alpine Source Files"

cd "$REPO_DIR/Alpine"

if [ ! -f "README.md" ]; then
    print_error "Alpine README.md not found!"
    exit 1
fi

SWIFT_FILE_COUNT=$(find Alpine -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "Found $SWIFT_FILE_COUNT Swift source files"

if [ "$SWIFT_FILE_COUNT" -lt 20 ]; then
    print_error "Missing source files! Expected ~27 files."
    exit 1
fi

print_step "All source files present"

# Step 5: Check for existing Xcode project
print_header "Step 5: Xcode Project Setup"

if [ -f "Alpine.xcodeproj/project.pbxproj" ]; then
    print_info "Xcode project already exists"

    echo -n "Do you want to open it now? (y/n): "
    read OPEN_NOW

    if [[ "$OPEN_NOW" =~ ^[Yy]$ ]]; then
        print_info "Opening Xcode project..."
        open Alpine.xcodeproj
        print_step "Project opened in Xcode"

        echo ""
        echo -e "${YELLOW}Next steps in Xcode:${NC}"
        echo "1. Select a simulator (iPhone 15 or similar)"
        echo "2. Press ⌘R to build and run"
        echo "3. Grant calendar permissions when prompted"
        echo "4. Explore the app!"
        exit 0
    fi
else
    print_info "No Xcode project found. You need to create one."
    echo ""
    echo -e "${YELLOW}Creating Xcode project requires Xcode GUI. Here's what to do:${NC}"
    echo ""
    echo "1. Open Xcode"
    echo "2. File → New → Project"
    echo "3. Choose: iOS → App"
    echo "4. Configure:"
    echo "   - Product Name: Alpine"
    echo "   - Interface: SwiftUI"
    echo "   - Language: Swift"
    echo "5. Save location: $REPO_DIR/Alpine/"
    echo "6. Delete auto-generated ContentView.swift"
    echo "7. Add all files from Alpine/Alpine/ directory"
    echo "8. Add Calendar capability"
    echo "9. Set deployment target to iOS 17.0"
    echo ""

    echo -n "Press Enter to open Xcode now (you'll follow steps above): "
    read

    open -a Xcode

    echo ""
    print_info "After creating the project in Xcode, run this script again to verify."
    exit 0
fi

# Step 6: Build verification (if xcodeproj exists)
print_header "Step 6: Build Verification"

echo "Attempting to build project..."

# Find schemes
SCHEME=$(xcodebuild -list -project Alpine.xcodeproj 2>/dev/null | grep -A 100 "Schemes:" | grep "Alpine" | head -n 1 | xargs)

if [ -z "$SCHEME" ]; then
    SCHEME="Alpine"
fi

print_info "Using scheme: $SCHEME"

# Try to build (this validates the project setup)
echo "Building for iOS Simulator..."

xcodebuild -scheme "$SCHEME" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
    -quiet \
    clean build 2>&1 | grep -E "error:|warning:|BUILD SUCCEEDED|BUILD FAILED" || true

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    print_step "Build succeeded!"
else
    print_error "Build failed. Check Xcode for errors."
    echo "Opening project in Xcode for manual inspection..."
    open Alpine.xcodeproj
    exit 1
fi

# Step 7: Success!
print_header "Step 7: Setup Complete! 🎉"

echo -e "${GREEN}Alpine MVP is ready to run!${NC}"
echo ""
echo "Quick start:"
echo "  cd $REPO_DIR/Alpine"
echo "  open Alpine.xcodeproj"
echo ""
echo "Then in Xcode:"
echo "  1. Select iPhone 15 simulator (or any iPhone)"
echo "  2. Press ⌘R to run"
echo ""
echo "Testing checklist:"
echo "  □ Complete onboarding (Student or Professional mode)"
echo "  □ Grant calendar access"
echo "  □ Create a note"
echo "  □ Ask AI a question in Console"
echo "  □ Watch AI Core level up!"
echo ""
echo "Documentation:"
echo "  • README.md - Architecture overview"
echo "  • SETUP_GUIDE.md - Detailed setup steps"
echo "  • PROJECT_STRUCTURE.md - File breakdown"
echo ""
echo -e "${BLUE}Happy coding! 🏔️✨${NC}"

# Offer to open Xcode
echo ""
echo -n "Open project in Xcode now? (y/n): "
read OPEN_XCODE

if [[ "$OPEN_XCODE" =~ ^[Yy]$ ]]; then
    open Alpine.xcodeproj
    print_step "Xcode launched!"
fi
