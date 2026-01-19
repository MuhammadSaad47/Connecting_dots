#!/bin/bash

echo "⚡ Fast APK Build..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Skip clean for speed (only clean if you have issues)
# flutter clean

echo "📦 Getting dependencies..."
flutter pub get --no-precompile

echo "🔥 Building APK (optimized for speed)..."
flutter build apk --debug \
    --no-pub \
    --no-web-resources-cdn \
    --no-tree-shake-icons \
    --no-sound-null-safety \
    --no-enable-impeller

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ APK built in record time!"
    
    # Copy to Downloads
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/app.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK copied to: $DEST_PATH"
        echo ""
        echo "🚀 Ready to install on Android!"
    else
        echo "❌ APK not found"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
