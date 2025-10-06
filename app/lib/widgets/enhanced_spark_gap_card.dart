import 'package:flutter/material.dart';
import 'package:stormtune/utils/theme.dart';

class EnhancedSparkGapCard extends StatelessWidget {
  final Map<String, dynamic> sparkGap;

  const EnhancedSparkGapCard({
    super.key,
    required this.sparkGap,
  });

  @override
  Widget build(BuildContext context) {
    final gapIn = (sparkGap['gap_in'] as List?)?.cast<double>() ?? [0.0, 0.0];
    final gapMm = (sparkGap['gap_mm'] as List?)?.cast<double>() ?? [0.0, 0.0];
    final notes = (sparkGap['notes'] as List?)?.cast<String>() ?? [];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.electrical_services,
                  color: StormTuneTheme.primaryBlue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Spark Plug Gap',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGapDisplay(gapIn, gapMm),
            const SizedBox(height: 16),
            _buildNotes(notes),
          ],
        ),
      ),
    );
  }

  Widget _buildGapDisplay(List<double> gapIn, List<double> gapMm) {
    return Row(
      children: [
        Expanded(
          child: _buildGapUnit(
            'Inches',
            gapIn,
            'in',
            StormTuneTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGapUnit(
            'Millimeters',
            gapMm,
            'mm',
            StormTuneTheme.accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildGapUnit(
    String title,
    List<double> values,
    String unit,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                values[0].toStringAsFixed(3),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                ' - ${values[1].toStringAsFixed(3)} $unit',
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(List<String> notes) {
    if (notes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...notes.map((note) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: StormTuneTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  note,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
