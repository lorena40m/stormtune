import 'package:flutter/foundation.dart';
import 'package:stormtune/models/car_profile.dart';
import 'package:stormtune/services/database_service.dart';

class CarProfileProvider extends ChangeNotifier {
  List<CarProfile> _profiles = [];
  CarProfile? _selectedProfile;
  bool _isLoading = false;
  String? _errorMessage;

  List<CarProfile> get profiles => _profiles;
  CarProfile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CarProfileProvider() {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    _setLoading(true);
    _clearError();

    try {
      _profiles = await DatabaseService.getCarProfiles();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load car profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveProfile(CarProfile profile) async {
    _setLoading(true);
    _clearError();

    try {
      await DatabaseService.saveCarProfile(profile);
      await loadProfiles(); // Reload the list
      
      // If this is the first profile, select it
      if (_profiles.length == 1) {
        _selectedProfile = profile;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to save car profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProfile(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await DatabaseService.deleteCarProfile(id);
      
      // If we're deleting the selected profile, clear the selection
      if (_selectedProfile?.id == id) {
        _selectedProfile = null;
      }
      
      await loadProfiles(); // Reload the list
    } catch (e) {
      _setError('Failed to delete car profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  void selectProfile(String? profileId) {
    if (profileId == null) {
      _selectedProfile = null;
    } else {
      _selectedProfile = _profiles.firstWhere(
        (profile) => profile.id == profileId,
        orElse: () => _profiles.first,
      );
    }
    notifyListeners();
  }

  void selectProfileByObject(CarProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  CarProfile? getProfileById(String id) {
    try {
      return _profiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
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