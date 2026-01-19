# One-Command APK Builder

## Quick Usage
Run this single command to build APK and copy to Downloads:

```bash
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots
./build_and_copy.sh
```

## What it does:
1. 🔨 Cleans and builds debug APK
2. 📦 Copies APK to `~/Downloads/connecting-dots.apk`
3. 📱 Shows installation instructions

## Manual Alternative (if script doesn't work):
```bash
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots
flutter clean
flutter pub get
flutter build apk --debug
cp build/app/outputs/flutter-apk/app-debug.apk ~/Downloads/connecting-dots.apk
```

## Install on Android:
1. Transfer `connecting-dots.apk` from Downloads to phone
2. Settings → Security → Enable "Unknown sources"
3. Open APK file → Install

## Direct Install (with USB):
```bash
adb install ~/Downloads/connecting-dots.apk
```
