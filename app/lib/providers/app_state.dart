import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stormtune/models/track_config.dart';

class AppState extends ChangeNotifier {
  bool _isFirstLaunch = true;
  String _selectedRaceMode = 'street';
  bool _basicMode = true;
  String? _selectedCarProfileId;
  bool _isLoading = false;
  String? _errorMessage;
  TrackConfig _trackConfig = TrackConfig(
    surface: 'asphalt',
    condition: 'dry',
    prep: 'unprepped',
  );

  bool get isFirstLaunch => _isFirstLaunch;
  String get selectedRaceMode => _selectedRaceMode;
  bool get basicMode => _basicMode;
  String? get selectedCarProfileId => _selectedCarProfileId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TrackConfig get trackConfig => _trackConfig;

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
      
      // Load track config
      final surface = prefs.getString('trackSurface') ?? 'asphalt';
      final condition = prefs.getString('trackCondition') ?? 'dry';
      final prep = prefs.getString('trackPrep') ?? 'unprepped';
      final trackTemp = prefs.getDouble('trackTempC');
      
      _trackConfig = TrackConfig(
        surface: surface,
        condition: condition,
        prep: prep,
        trackTempC: trackTemp,
      );
      
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
      
      // Save track config
      await prefs.setString('trackSurface', _trackConfig.surface);
      await prefs.setString('trackCondition', _trackConfig.condition);
      await prefs.setString('trackPrep', _trackConfig.prep);
      if (_trackConfig.trackTempC != null) {
        await prefs.setDouble('trackTempC', _trackConfig.trackTempC!);
      } else {
        await prefs.remove('trackTempC');
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

  void setTrackConfig(TrackConfig config) {
    _trackConfig = config;
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
