import 'package:flutter/material.dart';
import 'package:stormtune/utils/theme.dart';

class SparkGapCard extends StatelessWidget {
  final Map<String, dynamic> sparkGap;

  const SparkGapCard({
    super.key,
    required this.sparkGap,
  });

  @override
  Widget build(BuildContext context) {
    final gapIn = sparkGap['gap_in'] as List<double>? ?? [0.0, 0.0];
    final gapMm = sparkGap['gap_mm'] as List<double>? ?? [0.0, 0.0];
    final notes = sparkGap['notes'] as List<String>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: StormTuneTheme.warningYellow,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Gap Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gap measurements
            Row(
              children: [
                Expanded(
                  child: _buildGapMeasurement(
                    label: 'Inches',
                    minValue: gapIn[0],
                    maxValue: gapIn[1],
                    color: StormTuneTheme.primaryRed,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGapMeasurement(
                    label: 'Millimeters',
                    minValue: gapMm[0],
                    maxValue: gapMm[1],
                    color: StormTuneTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notes
            if (notes.isNotEmpty) ...[
              const Text(
                'Notes:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...notes.map((note) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        note,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],

            const SizedBox(height: 16),

            // Warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Always measure and verify gap after installation. '
                      'Gap may need adjustment based on specific engine conditions.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGapMeasurement({
    required String label,
    required double minValue,
    required double maxValue,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${minValue.toStringAsFixed(3)} - ${maxValue.toStringAsFixed(3)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 