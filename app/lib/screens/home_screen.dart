import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/app_state.dart';
import 'package:stormtune/providers/weather_provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/screens/car_setup_screen.dart';
import 'package:stormtune/screens/weather_screen.dart';
import 'package:stormtune/screens/recommendations_screen.dart';
import 'package:stormtune/screens/profiles_screen.dart';
import 'package:stormtune/screens/track_config_screen.dart';
import "package:stormtune/models/track_config.dart";
import 'package:stormtune/widgets/weather_card.dart';
import 'package:stormtune/widgets/car_profile_card.dart';
import 'package:stormtune/widgets/race_mode_selector.dart';
import 'package:stormtune/utils/theme.dart';
import "package:stormtune/widgets/network_status_indicator.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      if (appState.isFirstLaunch) {
        _showWelcomeDialog();
      }
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to StormTune!'),
        content: const Text(
          'Get smart tuning recommendations based on your car setup, weather conditions, and track configuration. '
          'Start by setting up your car profile, current weather, and track conditions.',
        ),
        actions: [
          const NetworkStatusIndicator(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Add settings screen
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StormTune'),
        actions: [
          const NetworkStatusIndicator(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Add settings screen
            },
          ),
        ],
      ),
      body: Consumer3<AppState, WeatherProvider, CarProfileProvider>(
        builder: (context, appState, weatherProvider, carProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await weatherProvider.fetchWeatherData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Race Mode Selector
                  const RaceModeSelector(),
                  const SizedBox(height: 20),

                  // Weather Card
                  WeatherCard(
                    weather: weatherProvider.currentWeather,
                    isLoading: weatherProvider.isLoading,
                    isOffline: weatherProvider.isOffline,
                    onRefresh: () => weatherProvider.fetchWeatherData(),
                    onManualEntry: () => _navigateToWeather(),
                  ),
                  const SizedBox(height: 20),

                  // Car Profile Card
                  CarProfileCard(
                    profile: carProvider.selectedProfile,
                    onSelect: () => _navigateToProfiles(),
                    onSetup: () => _navigateToCarSetup(),
                  ),
                  const SizedBox(height: 20),

                  // Track Configuration Card
                  _buildTrackConfigCard(appState),
                  const SizedBox(height: 20),

                  // Get Recommendations Button
                  if (weatherProvider.currentWeather != null && 
                      carProvider.selectedProfile != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToRecommendations(),
                        icon: const Icon(Icons.tune),
                        label: const Text(
                          'Get Tuning Recommendations',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                  // Status Messages
                  if (weatherProvider.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        weatherProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),

                  if (carProvider.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        carProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackConfigCard(AppState appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.track_changes,
                  color: StormTuneTheme.primaryBlue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Track Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToTrackConfig(),
                  child: const Text('Configure'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTrackInfo(appState.trackConfig),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackInfo(trackConfig) {
    return Column(
      children: [
        _buildInfoRow('Surface', trackConfig.surfaceDisplayName),
        _buildInfoRow('Condition', trackConfig.conditionDisplayName),
        _buildInfoRow('Preparation', trackConfig.prepDisplayName),
        if (trackConfig.trackTempC != null)
          _buildInfoRow('Temperature', '${trackConfig.trackTempC!.toStringAsFixed(1)}°C'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToWeather() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WeatherScreen()),
    );
  }

  void _navigateToCarSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CarSetupScreen()),
    );
  }

  void _navigateToProfiles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilesScreen()),
    );
  }

  void _navigateToTrackConfig() async {
    final result = await Navigator.push<TrackConfig>(
      context,
      MaterialPageRoute(builder: (context) => const TrackConfigScreen()),
    );
    
    if (result != null) {
      context.read<AppState>().setTrackConfig(result);
    }
  }

  void _navigateToRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecommendationsScreen()),
    );
  }
}
