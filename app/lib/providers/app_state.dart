import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isFirstLaunch = true;
  String _selectedRaceMode = 'street';
  bool _basicMode = true;
  String? _selectedCarProfileId;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isFirstLaunch => _isFirstLaunch;
  String get selectedRaceMode => _selectedRaceMode;
  bool get basicMode => _basicMode;
  String? get selectedCarProfileId => _selectedCarProfileId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _selectedRaceMode = prefs.getString('selectedRaceMode') ?? 'street';
      _basicMode = prefs.getBool('basicMode') ?? true;
      _selectedCarProfileId = prefs.getString('selectedCarProfileId');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', _isFirstLaunch);
      await prefs.setString('selectedRaceMode', _selectedRaceMode);
      await prefs.setBool('basicMode', _basicMode);
      if (_selectedCarProfileId != null) {
        await prefs.setString('selectedCarProfileId', _selectedCarProfileId!);
      }
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  void setFirstLaunch(bool value) {
    _isFirstLaunch = value;
    _savePreferences();
    notifyListeners();
  }

  void setRaceMode(String raceMode) {
    _selectedRaceMode = raceMode;
    _savePreferences();
    notifyListeners();
  }

  void setBasicMode(bool basicMode) {
    _basicMode = basicMode;
    _savePreferences();
    notifyListeners();
  }

  void setSelectedCarProfile(String? profileId) {
    _selectedCarProfileId = profileId;
    _savePreferences();
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 