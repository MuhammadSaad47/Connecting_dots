#!/bin/bash

echo "🔧 Fixing Android SDK completely..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Kill any running Android processes
sudo pkill -f gradle 2>/dev/null || true
sudo pkill -f java 2>/dev/null || true

# Fix all Android SDK permissions
sudo mkdir -p /usr/lib/android-sdk/licenses
sudo chmod -R 777 /usr/lib/android-sdk
sudo chown -R $USER:$USER /usr/lib/android-sdk 2>/dev/null || true

# Create user-local Android SDK if system one fails
mkdir -p $HOME/.android-sdk
export ANDROID_HOME=$HOME/.android-sdk
export ANDROID_SDK_ROOT=$HOME/.android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Accept all licenses automatically
mkdir -p $HOME/.android-sdk/licenses
echo "8933bad161af4178b1185d1a37fbf41ea5269cda" > $HOME/.android-sdk/licenses/android-sdk-license
echo "d56f51874794519677ac0ec1d8f689796b6ff" > $HOME/.android-sdk/licenses/android-sdk-preview-license

echo "🧹 Cleaning Flutter..."
flutter clean
rm -rf .dart_tool
rm -rf build

echo "📦 Getting dependencies..."
flutter pub get

echo "🔥 Building APK with user SDK..."
flutter build apk --debug --verbose

# Check if build succeeded
if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/connecting-dots.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK copied to: $DEST_PATH"
        echo ""
        echo "📋 Install on Android:"
        echo "1. Transfer connecting-dots.apk to phone"
        echo "2. Settings → Security → Enable 'Unknown sources'"
        echo "3. Open APK and install"
    else
        echo "❌ APK not found at expected location"
        echo "🔍 Checking alternative locations..."
        find build -name "*.apk" -type f 2>/dev/null
    fi
else
    echo "❌ Build failed!"
    echo "🔍 Try alternative: flutter build apk --split-debug-abi"
    echo "📱 Or use web version: flutter run -d chrome"
fi
