import 'package:flutter/material.dart';
import 'package:stormtune/models/tuning_recommendation.dart';
import 'package:stormtune/utils/theme.dart';

class EnhancedRecommendationCard extends StatelessWidget {
  final TuningRecommendation recommendation;

  const EnhancedRecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuning Corrections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCorrectionGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildCorrectionItem(
          'Launch RPM',
          '${recommendation.launchRpm}',
          Icons.speed,
          _getRpmColor(recommendation.launchRpm),
        ),
        _buildCorrectionItem(
          'Fuel Trim',
          '${recommendation.fuelTrimPct.toStringAsFixed(1)}%',
          Icons.local_gas_station,
          _getTrimColor(recommendation.fuelTrimPct),
        ),
        _buildCorrectionItem(
          'Ignition Trim',
          '${recommendation.ignitionTrimDeg.toStringAsFixed(1)}°',
          Icons.flash_on,
          _getTrimColor(recommendation.ignitionTrimDeg),
        ),
        _buildCorrectionItem(
          'WGDC Trim',
          '${recommendation.wgdcTrimPct.toStringAsFixed(1)}%',
          Icons.tune,
          _getTrimColor(recommendation.wgdcTrimPct),
        ),
        _buildCorrectionItem(
          'Antilag',
          recommendation.antilag.toUpperCase(),
          Icons.timeline,
          _getAntilagColor(recommendation.antilag),
        ),
        if (recommendation.tirePressureHotPsi != null)
          _buildCorrectionItem(
            'Tire Pressure',
            '${recommendation.tirePressureHotPsi!.toStringAsFixed(1)} PSI',
            Icons.circle,
            StormTuneTheme.primaryBlue,
          ),
      ],
    );
  }

  Widget _buildCorrectionItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRpmColor(int rpm) {
    if (rpm > 6000) return StormTuneTheme.primaryRed;
    if (rpm > 5000) return StormTuneTheme.warningYellow;
    return StormTuneTheme.successGreen;
  }

  Color _getTrimColor(double trim) {
    if (trim > 5) return StormTuneTheme.primaryRed;
    if (trim > 2) return StormTuneTheme.warningYellow;
    if (trim < -5) return StormTuneTheme.primaryRed;
    if (trim < -2) return StormTuneTheme.warningYellow;
    return StormTuneTheme.successGreen;
  }

  Color _getAntilagColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return StormTuneTheme.primaryRed;
      case 'medium':
        return StormTuneTheme.warningYellow;
      case 'low':
        return StormTuneTheme.successGreen;
      default:
        return Colors.grey;
    }
  }
}
