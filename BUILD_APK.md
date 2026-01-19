# How to Build APK for Android

## Prerequisites
1. Make sure you have Android SDK installed
2. Enable USB debugging on your Android phone
3. Connect your phone via USB

## Build APK

### Option 1: Debug APK (for testing)
```bash
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots
flutter build apk --debug
```

### Option 2: Release APK (for production)
```bash
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots
flutter build apk --release
```

## Install APK

### Method 1: Direct Install (if connected)
```bash
flutter install
```

### Method 2: Manual Install
1. After building, APK will be in:
   - Debug: `build/app/outputs/flutter-apk/app-debug.apk`
   - Release: `build/app/outputs/flutter-apk/app-release.apk`

2. Transfer APK to your phone:
   ```bash
   # Using ADB
   adb install build/app/outputs/flutter-apk/app-debug.apk
   
   # Or copy to phone and install manually
   cp build/app/outputs/flutter-apk/app-debug.apk ~/Downloads/
   ```

3. On your phone:
   - Enable "Install from unknown sources" in settings
   - Open the APK file and install

## Common Issues & Solutions

### Issue: "INSTALL_FAILED_INSUFFICIENT_STORAGE"
- Free up space on your phone
- Use `flutter clean` before building

### Issue: "INSTALL_FAILED_VERSION_DOWNGRADE"
- Uninstall old version first:
  ```bash
  adb uninstall com.example.connecting_dots
  ```

### Issue: App crashes on startup
- Check if you have the latest Flutter version
- Run `flutter doctor` to check dependencies

## Build for Specific Architecture
```bash
# For ARM64 devices (most phones)
flutter build apk --release --target-platform android-arm64

# For ARM32 devices
flutter build apk --release --target-platform android-arm
```

## Signed APK (for Play Store)
```bash
# Create keystore first (one time)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Build signed APK
flutter build apk --release --signing-key upload-keystore.jks --signing-key-password YOUR_PASSWORD
```
