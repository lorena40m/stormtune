import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/weather_provider.dart';
import 'package:stormtune/utils/theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();
  final _pressureController = TextEditingController();
  final _iatController = TextEditingController();
  final _cltController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentWeather();
  }

  void _loadCurrentWeather() {
    final weather = context.read<WeatherProvider>().currentWeather;
    if (weather != null) {
      _tempController.text = weather.temperatureC.toStringAsFixed(1);
      _humidityController.text = weather.humidityPct?.toStringAsFixed(1) ?? '';
      _pressureController.text = weather.pressureHpa?.toStringAsFixed(1) ?? '';
      _iatController.text = weather.iatC?.toStringAsFixed(1) ?? '';
      _cltController.text = weather.cltC?.toStringAsFixed(1) ?? '';
    }
  }

  @override
  void dispose() {
    _tempController.dispose();
    _humidityController.dispose();
    _pressureController.dispose();
    _iatController.dispose();
    _cltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Setup'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auto-fetch section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Auto-Fetch Weather',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Automatically fetch current weather data using your location.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: weatherProvider.isLoading 
                                ? null 
                                : () => weatherProvider.fetchWeatherData(),
                            icon: weatherProvider.isLoading 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.location_on),
                            label: Text(
                              weatherProvider.isLoading 
                                  ? 'Fetching...' 
                                  : 'Fetch Current Weather',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Manual entry section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manual Weather Entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter weather conditions manually if auto-fetch is unavailable.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // Temperature
                          TextFormField(
                            controller: _tempController,
                            decoration: const InputDecoration(
                              labelText: 'Temperature (°C)',
                              hintText: '25.0',
                              prefixIcon: Icon(Icons.thermostat),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Temperature is required';
                              }
                              final temp = double.tryParse(value);
                              if (temp == null || temp < -50 || temp > 100) {
                                return 'Enter a valid temperature (-50 to 100°C)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Humidity
                          TextFormField(
                            controller: _humidityController,
                            decoration: const InputDecoration(
                              labelText: 'Humidity (%)',
                              hintText: '50.0',
                              prefixIcon: Icon(Icons.water_drop),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final humidity = double.tryParse(value);
                                if (humidity == null || humidity < 0 || humidity > 100) {
                                  return 'Enter a valid humidity (0-100%)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Pressure
                          TextFormField(
                            controller: _pressureController,
                            decoration: const InputDecoration(
                              labelText: 'Barometric Pressure (hPa)',
                              hintText: '1013.25',
                              prefixIcon: Icon(Icons.speed),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final pressure = double.tryParse(value);
                                if (pressure == null || pressure < 800 || pressure > 1200) {
                                  return 'Enter a valid pressure (800-1200 hPa)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // IAT
                          TextFormField(
                            controller: _iatController,
                            decoration: const InputDecoration(
                              labelText: 'Intake Air Temperature (°C)',
                              hintText: '35.0',
                              prefixIcon: Icon(Icons.air),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final iat = double.tryParse(value);
                                if (iat == null || iat < -50 || iat > 150) {
                                  return 'Enter a valid IAT (-50 to 150°C)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // CLT
                          TextFormField(
                            controller: _cltController,
                            decoration: const InputDecoration(
                              labelText: 'Coolant Temperature (°C)',
                              hintText: '90.0',
                              prefixIcon: Icon(Icons.whatshot),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final clt = double.tryParse(value);
                                if (clt == null || clt < 0 || clt > 150) {
                                  return 'Enter a valid CLT (0-150°C)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: weatherProvider.isLoading 
                                  ? null 
                                  : _saveManualWeather,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Weather Data'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Error message
                if (weatherProvider.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
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
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveManualWeather() {
    if (_formKey.currentState!.validate()) {
      final weatherProvider = context.read<WeatherProvider>();
      
      weatherProvider.updateWeatherManually(
        temperatureC: double.parse(_tempController.text),
        humidityPct: _humidityController.text.isNotEmpty 
            ? double.parse(_humidityController.text) 
            : null,
        pressureHpa: _pressureController.text.isNotEmpty 
            ? double.parse(_pressureController.text) 
            : null,
        iatC: _iatController.text.isNotEmpty 
            ? double.parse(_iatController.text) 
            : null,
        cltC: _cltController.text.isNotEmpty 
            ? double.parse(_cltController.text) 
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weather data saved successfully'),
          backgroundColor: StormTuneTheme.successGreen,
        ),
      );

      Navigator.pop(context);
    }
  }
} 