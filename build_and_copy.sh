#!/bin/bash

echo "🔨 Building APK..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Clean and build
flutter clean
flutter pub get

echo "📦 Building debug APK..."
flutter build apk --debug

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    
    # Copy to Downloads
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/connecting-dots.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK copied to: $DEST_PATH"
        echo ""
        echo "📋 Next steps:"
        echo "1. Transfer 'connecting-dots.apk' from Downloads to your Android phone"
        echo "2. On Android: Enable 'Install from unknown sources' in Settings"
        echo "3. Open the APK file and install"
        echo ""
        echo "🔗 Or install directly with ADB (if connected):"
        echo "adb install '$DEST_PATH'"
    else
        echo "❌ APK file not found at expected location"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
