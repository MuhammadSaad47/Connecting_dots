#!/bin/bash

echo "⚡ Simple APK Build..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Basic clean build
flutter clean
flutter pub get

echo "🔥 Building APK..."
flutter build apk --debug

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    
    # Copy to Downloads
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/app.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK copied to: $DEST_PATH"
        echo ""
        echo "🚀 Ready for Android installation!"
    else
        echo "❌ APK file not found"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
