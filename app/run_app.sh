#!/bin/bash

echo "🚀 StormTune Flutter App Setup"
echo "================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo "📱 $FLUTTER_VERSION"

# Clean and get dependencies
echo "📦 Installing dependencies..."
flutter clean
flutter pub get

# Check for connected devices
echo "🔍 Checking for connected devices..."
flutter devices

echo ""
echo "🎯 To run the app:"
echo "   flutter run"
echo ""
echo "📱 For specific device:"
echo "   flutter run -d <device-id>"
echo ""
echo "🔧 For web (if supported):"
echo "   flutter run -d chrome"
echo ""
echo "⚠️  Remember to:"
echo "   1. Update OpenWeatherMap API key in lib/services/weather_service.dart"
echo "   2. Update backend URL in lib/services/api_service.dart if needed"
echo "   3. Start the backend server before testing recommendations" 