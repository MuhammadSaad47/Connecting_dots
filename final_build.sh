#!/bin/bash

echo "🔥 FINAL APK BUILD - SYSTEM OVERRIDE"
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Override all system paths
export PATH="/usr/bin:/bin:/usr/local/bin"
export ANDROID_HOME="/usr/lib/android-sdk"
export ANDROID_SDK_ROOT="/usr/lib/android-sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Remove Xilinx paths completely
unset CMAKE_PREFIX_PATH
unset LD_LIBRARY_PATH

# Force use system cmake
export CMAKE_COMMAND="/usr/bin/cmake"

echo "🧹 Deep clean..."
rm -rf build
rm -rf .dart_tool
rm -rf android/.gradle
flutter clean

echo "📦 Dependencies..."
flutter pub get

echo "🔥 BUILDING APK - FINAL ATTEMPT..."
flutter build apk --debug --verbose 2>&1 | tee build.log

# Check result
if [ $? -eq 0 ]; then
    echo "✅ SUCCESS! APK BUILT!"
    
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    DEST_PATH="$HOME/Downloads/CONNECTING_DOTS_FINAL.apk"
    
    if [ -f "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST_PATH"
        echo "📱 APK READY: $DEST_PATH"
        echo "📏 SIZE: $(du -h "$DEST_PATH" | cut -f1)"
        echo ""
        echo "🚀 INSTALL ON ANDROID:"
        echo "1. Transfer CONNECTING_DOTS_FINAL.apk to phone"
        echo "2. Settings → Security → Unknown Sources → ON"
        echo "3. Open APK → Install"
    else
        echo "❌ APK not found. Searching..."
        find build -name "*.apk" -type f -exec ls -lh {} \;
    fi
else
    echo "❌ BUILD FAILED"
    echo "📋 Check build.log for details"
    echo ""
    echo "🔥 LAST RESORT - USE ONLINE BUILDER:"
    echo "https://app.apk.online - Upload Flutter project → Get APK"
fi
