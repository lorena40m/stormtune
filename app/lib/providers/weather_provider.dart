import 'package:flutter/foundation.dart';
import 'package:stormtune/models/weather_data.dart';
import 'package:stormtune/services/weather_service.dart';
import 'package:stormtune/services/database_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherData? _currentWeather;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOffline = false;

  WeatherData? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;

  WeatherProvider() {
    _loadCachedWeather();
  }

  Future<void> _loadCachedWeather() async {
    try {
      final cachedWeather = await DatabaseService.getLatestWeatherData();
      if (cachedWeather != null) {
        _currentWeather = cachedWeather;
        _isOffline = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cached weather: $e');
    }
  }

  Future<void> fetchWeatherData() async {
    _setLoading(true);
    _clearError();

    try {
      final weather = await WeatherService.getWeatherData();
      _currentWeather = weather;
      _isOffline = false;
      
      // Cache the weather data
      await DatabaseService.saveWeatherData(weather);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch weather data: $e');
      // Try to load cached data if available
      await _loadCachedWeather();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateWeatherManually({
    required double temperatureC,
    double? humidityPct,
    double? pressureHpa,
    double? iatC,
    double? cltC,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final weather = WeatherData(
        temperatureC: temperatureC,
        humidityPct: humidityPct,
        pressureHpa: pressureHpa,
        iatC: iatC,
        cltC: cltC,
        location: 'Manual Entry',
        timestamp: DateTime.now(),
      );

      _currentWeather = weather;
      _isOffline = true;
      
      // Cache the manual weather data
      await DatabaseService.saveWeatherData(weather);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to save manual weather data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
} 