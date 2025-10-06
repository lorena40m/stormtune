import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/app_state.dart';
import 'package:stormtune/providers/weather_provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/screens/car_setup_screen.dart';
import 'package:stormtune/screens/weather_screen.dart';
import 'package:stormtune/screens/recommendations_screen.dart';
import 'package:stormtune/screens/profiles_screen.dart';
import 'package:stormtune/widgets/weather_card.dart';
import 'package:stormtune/widgets/car_profile_card.dart';
import 'package:stormtune/widgets/race_mode_selector.dart';
import 'package:stormtune/utils/theme.dart';

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
          'Get smart tuning recommendations based on your car setup and weather conditions. '
          'Start by setting up your car profile and current weather.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppState>().setFirstLaunch(false);
              Navigator.of(context).pop();
            },
            child: const Text('Get Started'),
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

  void _navigateToRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecommendationsScreen()),
    );
  }
} 