import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/app_state.dart';
import 'package:stormtune/providers/weather_provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/models/tuning_recommendation.dart';
import 'package:stormtune/services/api_service.dart';
import 'package:stormtune/utils/theme.dart';
import "package:stormtune/widgets/enhanced_recommendation_card.dart";
import "package:stormtune/widgets/enhanced_spark_gap_card.dart";

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  TuningRecommendation? _recommendation;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getRecommendations();
  }

  Future<void> _getRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final appState = context.read<AppState>();
      final weatherProvider = context.read<WeatherProvider>();
      final carProvider = context.read<CarProfileProvider>();

      if (weatherProvider.currentWeather == null) {
        throw Exception('Weather data is required');
      }

      if (carProvider.selectedProfile == null) {
        throw Exception('Car profile is required');
      }

      // Build the payload for the API using track config from app state
      final payload = {
        'race_mode': appState.selectedRaceMode,
        'basic_mode': appState.basicMode,
        'ecu_brand': carProvider.selectedProfile!.ecuBrand,
        'ambient': {
          'temp_c': weatherProvider.currentWeather!.temperatureC,
          'humidity_pct': weatherProvider.currentWeather!.humidityPct,
          'baro_hpa': weatherProvider.currentWeather!.pressureHpa,
          'iat_c': weatherProvider.currentWeather!.iatC,
          'clt_c': weatherProvider.currentWeather!.cltC,
        },
        'track': appState.trackConfig.toJson(),
        'vehicle': {
          'drive': carProvider.selectedProfile!.drive,
          'induction': carProvider.selectedProfile!.induction,
          'fuel': carProvider.selectedProfile!.fuel,
          'tire': carProvider.selectedProfile!.tire,
          'weight_class': carProvider.selectedProfile!.weightClass,
          'ignition_strength': carProvider.selectedProfile!.ignitionStrength,
        },
        'baseline': {
          'launch_rpm': carProvider.selectedProfile!.launchRpm,
          'base_wgdc_pct': carProvider.selectedProfile!.baseWgdcPct,
          'afr_target_wot': carProvider.selectedProfile!.afrTargetWot,
          'tire_hot_pressure_psi': carProvider.selectedProfile!.tireHotPressurePsi,
          'boost_psi': carProvider.selectedProfile!.boostPsi,
        },
      };

      final recommendation = await ApiService.getRecommendations(payload: payload);
      
      setState(() {
        _recommendation = recommendation;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuning Recommendations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _getRecommendations,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing your setup...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _getRecommendations,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_recommendation == null) {
      return const Center(
        child: Text('No recommendations available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Race Mode Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _getRaceModeIcon(_recommendation!.raceMode),
                    color: _getRaceModeColor(_recommendation!.raceMode),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getRaceModeTitle(_recommendation!.raceMode),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _recommendation!.insight,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tuning Corrections
          const Text(
            'Tuning Corrections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          EnhancedRecommendationCard(recommendation: _recommendation!),
          const SizedBox(height: 20),

          // Spark Gap Recommendations
          const Text(
            'Spark Plug Gap',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          EnhancedSparkGapCard(sparkGap: _recommendation!.sparkGap),
          const SizedBox(height: 20),

          // Disclaimer
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Disclaimer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These recommendations are for guidance only. Always verify changes with proper testing and monitoring. '
                    'StormTune is not responsible for any damage or issues resulting from tuning modifications.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRaceModeIcon(String raceMode) {
    switch (raceMode) {
      case 'street':
        return Icons.directions_car;
      case 'drag':
        return Icons.speed;
      case 'circuit':
        return Icons.track_changes;
      case 'rally':
        return Icons.terrain;
      case 'drift':
        return Icons.rotate_right;
      default:
        return Icons.help_outline;
    }
  }

  Color _getRaceModeColor(String raceMode) {
    switch (raceMode) {
      case 'street':
        return StormTuneTheme.primaryBlue;
      case 'drag':
        return StormTuneTheme.primaryRed;
      case 'circuit':
        return StormTuneTheme.successGreen;
      case 'rally':
        return StormTuneTheme.accentOrange;
      case 'drift':
        return StormTuneTheme.warningYellow;
      default:
        return Colors.grey;
    }
  }

  String _getRaceModeTitle(String raceMode) {
    switch (raceMode) {
      case 'street':
        return 'Street Mode';
      case 'drag':
        return 'Drag Mode';
      case 'circuit':
        return 'Circuit Mode';
      case 'rally':
        return 'Rally Mode';
      case 'drift':
        return 'Drift Mode';
      default:
        return 'Unknown Mode';
    }
  }
}
