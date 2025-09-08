import 'package:flutter/material.dart';
import 'package:stormtune/models/tuning_recommendation.dart';
import 'package:stormtune/utils/theme.dart';

class RecommendationCard extends StatelessWidget {
  final TuningRecommendation recommendation;

  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Launch RPM
            _buildRecommendationItem(
              icon: Icons.trending_up,
              label: 'Launch RPM',
              value: '${recommendation.launchRpm}',
              unit: 'RPM',
              color: StormTuneTheme.primaryRed,
            ),
            const Divider(),
            
            // Fuel Trim
            _buildRecommendationItem(
              icon: Icons.local_gas_station,
              label: 'Fuel Trim',
              value: recommendation.fuelTrimPct >= 0 
                  ? '+${recommendation.fuelTrimPct.toStringAsFixed(1)}'
                  : recommendation.fuelTrimPct.toStringAsFixed(1),
              unit: '%',
              color: recommendation.fuelTrimPct >= 0 
                  ? StormTuneTheme.successGreen 
                  : StormTuneTheme.warningYellow,
            ),
            const Divider(),
            
            // Ignition Trim
            _buildRecommendationItem(
              icon: Icons.flash_on,
              label: 'Ignition Trim',
              value: recommendation.ignitionTrimDeg >= 0 
                  ? '+${recommendation.ignitionTrimDeg.toStringAsFixed(1)}'
                  : recommendation.ignitionTrimDeg.toStringAsFixed(1),
              unit: '°',
              color: recommendation.ignitionTrimDeg >= 0 
                  ? StormTuneTheme.successGreen 
                  : StormTuneTheme.warningYellow,
            ),
            const Divider(),
            
            // Wastegate Duty Cycle
            _buildRecommendationItem(
              icon: Icons.settings,
              label: 'WGDC Trim',
              value: recommendation.wgdcTrimPct >= 0 
                  ? '+${recommendation.wgdcTrimPct.toStringAsFixed(1)}'
                  : recommendation.wgdcTrimPct.toStringAsFixed(1),
              unit: '%',
              color: recommendation.wgdcTrimPct >= 0 
                  ? StormTuneTheme.primaryBlue 
                  : StormTuneTheme.accentOrange,
            ),
            const Divider(),
            
            // Anti-lag
            _buildRecommendationItem(
              icon: Icons.speed,
              label: 'Anti-lag',
              value: recommendation.antilag.toUpperCase(),
              unit: '',
              color: _getAntilagColor(recommendation.antilag),
            ),
            
            // Tire Pressure (if available)
            if (recommendation.tirePressureHotPsi != null) ...[
              const Divider(),
              _buildRecommendationItem(
                icon: Icons.tire_repair,
                label: 'Tire Pressure',
                value: recommendation.tirePressureHotPsi!.toStringAsFixed(1),
                unit: 'PSI',
                color: StormTuneTheme.darkGrey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14,
                          color: color.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAntilagColor(String antilag) {
    switch (antilag.toLowerCase()) {
      case 'off':
        return Colors.grey;
      case 'low':
        return StormTuneTheme.warningYellow;
      case 'medium':
        return StormTuneTheme.accentOrange;
      case 'high':
        return StormTuneTheme.primaryRed;
      default:
        return Colors.grey;
    }
  }
} 