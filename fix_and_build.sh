#!/bin/bash

echo "🔧 Fixing Android SDK permissions..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Fix Android SDK permissions
sudo chmod -R 755 /usr/lib/android-sdk 2>/dev/null || true
sudo chown -R $USER:$USER /usr/lib/android-sdk 2>/dev/null || true

# Create local Android SDK directory if system one is locked
mkdir -p ~/.android-sdk
export ANDROID_HOME="$HOME/.android-sdk"
export ANDROID_SDK_ROOT="$HOME/.android-sdk"

echo "📦 Building with local SDK..."
flutter clean
flutter pub get

# Try building with local Android SDK
flutter build apk --debug \
    --local-engine-src-path=/tmp \
    --no-pub \
    --verbose

# If still fails, try web build instead
if [ $? -ne 0 ]; then
    echo "🌐 APK build failed, trying web build..."
    flutter build web --no-pub
    
    if [ $? -eq 0 ]; then
        echo "✅ Web build successful!"
        echo "📱 Open in browser: http://localhost:3000"
        echo "🔥 Run: flutter run -d chrome"
    else
        echo "❌ Both builds failed. Try:"
        echo "1. sudo chmod -R 755 /usr/lib/android-sdk"
        echo "2. flutter doctor"
        echo "3. Restart your computer"
    fi
else
    # Copy APK if build succeeded
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/app.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK copied to: $DEST_PATH"
    fi
fi
