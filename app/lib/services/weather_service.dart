import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:stormtune/models/weather_data.dart';

class WeatherService {
  static const String apiKey = '19bc5bca7c073787bab4bbb1555055fc'; // Replace with actual key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<WeatherData> getWeatherData() async {
    try {
      final position = await getCurrentLocation();
      
      final response = await http.get(
        Uri.parse(
          '$baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        return WeatherData(
          temperatureC: data['main']['temp']?.toDouble() ?? 0.0,
          humidityPct: data['main']['humidity']?.toDouble(),
          pressureHpa: data['main']['pressure']?.toDouble(),
          location: data['name'],
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      // Return default weather data if API fails
      return WeatherData(
        temperatureC: 25.0,
        humidityPct: 50.0,
        pressureHpa: 1013.25,
        location: 'Unknown',
        timestamp: DateTime.now(),
      );
    }
  }

  static Future<String> getLocationName(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'] ?? 'Unknown Location';
      }
    } catch (e) {
      // Ignore errors for location name
    }
    return 'Unknown Location';
  }
} 