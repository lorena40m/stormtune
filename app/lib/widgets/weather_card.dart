import 'package:flutter/material.dart';
import 'package:stormtune/models/weather_data.dart';
import 'package:stormtune/utils/theme.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData? weather;
  final bool isLoading;
  final bool isOffline;
  final VoidCallback onRefresh;
  final VoidCallback onManualEntry;

  const WeatherCard({
    super.key,
    this.weather,
    required this.isLoading,
    required this.isOffline,
    required this.onRefresh,
    required this.onManualEntry,
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
                  'Weather Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (isOffline)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: isLoading ? null : onRefresh,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (weather == null)
              _buildNoWeatherData()
            else
              _buildWeatherData(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWeatherData() {
    return Column(
      children: [
        const Icon(
          Icons.cloud_off,
          size: 48,
          color: Colors.grey,
        ),
        const SizedBox(height: 12),
        const Text(
          'No weather data available',
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
                onPressed: onRefresh,
                icon: const Icon(Icons.location_on),
                label: const Text('Auto Fetch'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onManualEntry,
                icon: const Icon(Icons.edit),
                label: const Text('Manual Entry'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherData(BuildContext context) {
    final tempFormat = NumberFormat('#.#');
    final timeFormat = DateFormat('HH:mm');
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildWeatherItem(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: '${tempFormat.format(weather!.temperatureC)}°C',
                color: StormTuneTheme.primaryRed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildWeatherItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: weather!.humidityPct != null 
                    ? '${tempFormat.format(weather!.humidityPct!)}%'
                    : 'N/A',
                color: StormTuneTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildWeatherItem(
                icon: Icons.speed,
                label: 'Pressure',
                value: weather!.pressureHpa != null 
                    ? '${tempFormat.format(weather!.pressureHpa!)} hPa'
                    : 'N/A',
                color: StormTuneTheme.accentOrange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildWeatherItem(
                icon: Icons.access_time,
                label: 'Updated',
                value: timeFormat.format(weather!.timestamp),
                color: StormTuneTheme.darkGrey,
              ),
            ),
          ],
        ),
        if (weather!.location != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  weather!.location!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onManualEntry,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Manually'),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
} 