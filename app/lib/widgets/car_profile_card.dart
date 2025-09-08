import 'package:flutter/material.dart';
import 'package:stormtune/models/car_profile.dart';
import 'package:stormtune/utils/theme.dart';

class CarProfileCard extends StatelessWidget {
  final CarProfile? profile;
  final VoidCallback onSelect;
  final VoidCallback onSetup;

  const CarProfileCard({
    super.key,
    this.profile,
    required this.onSelect,
    required this.onSetup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Car Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onSelect,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (profile == null)
              _buildNoProfile()
            else
              _buildProfileData(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfile() {
    return Column(
      children: [
        const Icon(
          Icons.directions_car_outlined,
          size: 48,
          color: Colors.grey,
        ),
        const SizedBox(height: 12),
        const Text(
          'No car profile selected',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onSelect,
                icon: const Icon(Icons.list),
                label: const Text('Select Profile'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSetup,
                icon: const Icon(Icons.add),
                label: const Text('New Profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileData(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.directions_car, color: StormTuneTheme.primaryRed),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                profile!.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Basic specs
        Row(
          children: [
            Expanded(
              child: _buildSpecItem(
                icon: Icons.settings,
                label: 'Drive',
                value: profile!.drive,
                color: StormTuneTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSpecItem(
                icon: Icons.air,
                label: 'Induction',
                value: profile!.induction.toUpperCase(),
                color: StormTuneTheme.accentOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildSpecItem(
                icon: Icons.local_gas_station,
                label: 'Fuel',
                value: profile!.fuel,
                color: StormTuneTheme.successGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSpecItem(
                icon: Icons.tire_repair,
                label: 'Tire',
                value: _formatTireType(profile!.tire),
                color: StormTuneTheme.darkGrey,
              ),
            ),
          ],
        ),
        
        // Boost info if available
        if (profile!.boostPsi != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.speed, color: StormTuneTheme.warningYellow),
              const SizedBox(width: 8),
              Text(
                'Boost: ${profile!.boostPsi!.toStringAsFixed(1)} PSI',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        
        // Launch RPM
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.trending_up, color: StormTuneTheme.primaryRed),
            const SizedBox(width: 8),
            Text(
              'Launch RPM: ${profile!.launchRpm}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSelect,
                icon: const Icon(Icons.edit),
                label: const Text('Change Profile'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSetup,
                icon: const Icon(Icons.add),
                label: const Text('New Profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTireType(String tire) {
    switch (tire) {
      case 'drag_radial':
        return 'Drag Radial';
      case 'semislick':
        return 'Semi-Slick';
      default:
        return tire.substring(0, 1).toUpperCase() + tire.substring(1);
    }
  }
} 