import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/app_state.dart';
import 'package:stormtune/utils/theme.dart';

class RaceModeSelector extends StatelessWidget {
  const RaceModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Race Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildModeChip(
                      context,
                      'street',
                      'Street',
                      Icons.directions_car,
                      appState.selectedRaceMode == 'street',
                      () => appState.setRaceMode('street'),
                    ),
                    _buildModeChip(
                      context,
                      'drag',
                      'Drag',
                      Icons.speed,
                      appState.selectedRaceMode == 'drag',
                      () => appState.setRaceMode('drag'),
                    ),
                    _buildModeChip(
                      context,
                      'circuit',
                      'Circuit',
                      Icons.track_changes,
                      appState.selectedRaceMode == 'circuit',
                      () => appState.setRaceMode('circuit'),
                    ),
                    _buildModeChip(
                      context,
                      'rally',
                      'Rally',
                      Icons.terrain,
                      appState.selectedRaceMode == 'rally',
                      () => appState.setRaceMode('rally'),
                    ),
                    _buildModeChip(
                      context,
                      'drift',
                      'Drift',
                      Icons.rotate_right,
                      appState.selectedRaceMode == 'drift',
                      () => appState.setRaceMode('drift'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildModeDescription(appState.selectedRaceMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeChip(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : StormTuneTheme.primaryRed,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: StormTuneTheme.primaryRed,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildModeDescription(String mode) {
    String description;
    IconData icon;
    Color color;

    switch (mode) {
      case 'street':
        description = 'Optimized for daily driving with safety margins';
        icon = Icons.directions_car;
        color = StormTuneTheme.primaryBlue;
        break;
      case 'drag':
        description = 'Maximum acceleration and launch performance';
        icon = Icons.speed;
        color = StormTuneTheme.primaryRed;
        break;
      case 'circuit':
        description = 'Balanced performance for track consistency';
        icon = Icons.track_changes;
        color = StormTuneTheme.successGreen;
        break;
      case 'rally':
        description = 'Traction-focused for loose surfaces';
        icon = Icons.terrain;
        color = StormTuneTheme.accentOrange;
        break;
      case 'drift':
        description = 'Controlled slip and angle management';
        icon = Icons.rotate_right;
        color = StormTuneTheme.warningYellow;
        break;
      default:
        description = 'Select a race mode for specific recommendations';
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 