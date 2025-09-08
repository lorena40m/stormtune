# StormTune - Mobile App

StormTune is a smart racing tuning recommendation app that provides personalized tuning advice based on your car setup and current weather conditions.

## Features

### ✅ Must-Have Features (MVP)

- **Car Setup Input**: Create and manage car profiles with detailed specifications
- **Weather Auto-Fetch**: Automatically fetch local weather data using GPS
- **Manual Weather Entry**: Option to enter weather conditions manually
- **Tuning Recommendations**: Get personalized tuning advice for:
  - Fuel trim adjustments
  - Ignition timing modifications
  - Tire pressure recommendations
  - Spark plug gap settings
  - Launch RPM optimization
  - Wastegate duty cycle adjustments
  - Anti-lag settings
- **Race Mode Presets**: Choose from Street, Drag, Circuit, Rally, and Drift modes
- **Offline Capability**: Works with cached data when internet is unavailable

### 💡 Nice-to-Have Features (Future)

- ECU Map Screenshot Analysis
- Data Logging & Analytics
- Learning Engine
- Community Sharing
- Affiliate Marketplace Integration

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- OpenWeatherMap API key (for weather data)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd stormtune/app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   - Get an OpenWeatherMap API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Update the API key in `lib/services/weather_service.dart`
   - Update the backend URL in `lib/services/api_service.dart` if needed

4. **Run the app**
   ```bash
   flutter run
   ```

### Backend Setup

The app requires the StormTune backend API to be running. See the backend documentation for setup instructions.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── car_profile.dart
│   ├── weather_data.dart
│   └── tuning_recommendation.dart
├── providers/                # State management
│   ├── app_state.dart
│   ├── weather_provider.dart
│   └── car_profile_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── car_setup_screen.dart
│   ├── weather_screen.dart
│   ├── profiles_screen.dart
│   └── recommendations_screen.dart
├── services/                 # API and data services
│   ├── api_service.dart
│   ├── weather_service.dart
│   └── database_service.dart
├── widgets/                  # Reusable UI components
│   ├── weather_card.dart
│   ├── car_profile_card.dart
│   ├── race_mode_selector.dart
│   ├── recommendation_card.dart
│   └── spark_gap_card.dart
└── utils/                    # Utilities and themes
    └── theme.dart
```

## Usage

### 1. First Launch
- The app will show a welcome dialog
- Set up your first car profile
- Configure weather data

### 2. Car Profile Setup
- Enter your car's specifications
- Include drive type, induction, fuel type, tires
- Set baseline tuning parameters
- Save multiple profiles for different cars

### 3. Weather Configuration
- Auto-fetch current weather using GPS
- Or manually enter weather conditions
- Include temperature, humidity, pressure
- Optional: IAT and coolant temperatures

### 4. Get Recommendations
- Select your race mode
- Choose your car profile
- Get personalized tuning recommendations
- View spark plug gap advice

## API Integration

The app communicates with the StormTune backend API to get tuning recommendations. The API expects:

```json
{
  "race_mode": "street",
  "basic_mode": true,
  "ecu_brand": "Haltech",
  "ambient": {
    "temp_c": 25.0,
    "humidity_pct": 50.0,
    "baro_hpa": 1013.25,
    "iat_c": 35.0,
    "clt_c": 90.0
  },
  "track": {
    "surface": "asphalt",
    "condition": "dry",
    "prep": "unprepped",
    "track_temp_c": 25.0
  },
  "vehicle": {
    "drive": "FWD",
    "induction": "turbo",
    "fuel": "Pump",
    "tire": "drag_radial",
    "weight_class": "mid",
    "ignition_strength": "OEM"
  },
  "baseline": {
    "launch_rpm": 5500,
    "base_wgdc_pct": 55.0,
    "afr_target_wot": 11.8,
    "tire_hot_pressure_psi": 16.0,
    "boost_psi": 12.0
  }
}
```

## Dependencies

- **http**: API communication
- **geolocator**: Location services
- **shared_preferences**: Local preferences
- **sqflite**: Local database
- **provider**: State management
- **permission_handler**: Location permissions
- **intl**: Date formatting

## Permissions

The app requires the following permissions:

- **Location**: To fetch local weather data
- **Internet**: To communicate with APIs
- **Storage**: To cache data locally

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

StormTune provides tuning recommendations for educational purposes only. Always verify changes with proper testing and monitoring. The developers are not responsible for any damage or issues resulting from tuning modifications.

## Support

For support and questions:
- Check the documentation
- Open an issue on GitHub
- Contact the development team 