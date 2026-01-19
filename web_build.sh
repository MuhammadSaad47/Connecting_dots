#!/bin/bash

echo "🌐 Flutter Web Build (No Android SDK needed)..."
cd /home/s-a-a-d-y/Connecting\ Dots/connecting_dots

# Clean and build web
flutter clean
flutter pub get

echo "🔥 Building for web..."
flutter build web --no-pub

if [ $? -eq 0 ]; then
    echo "✅ Web build successful!"
    echo ""
    echo "🚀 To run locally:"
    echo "cd build/web"
    echo "python3 -m http.server 8000"
    echo ""
    echo "📱 Or use Flutter to serve:"
    echo "flutter run -d chrome --web-port=3000"
    echo ""
    echo "🔗 Access from any device on same network:"
    echo "http://localhost:8000 or http://YOUR_IP:8000"
else
    echo "❌ Web build failed!"
fi
