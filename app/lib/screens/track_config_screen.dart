import 'package:flutter/material.dart';
import 'package:stormtune/models/track_config.dart';
import 'package:stormtune/utils/theme.dart';

class TrackConfigScreen extends StatefulWidget {
  const TrackConfigScreen({super.key});

  @override
  State<TrackConfigScreen> createState() => _TrackConfigScreenState();
}

class _TrackConfigScreenState extends State<TrackConfigScreen> {
  late TrackConfig _trackConfig;
  final _formKey = GlobalKey<FormState>();
  final _trackTempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trackConfig = TrackConfig(
      surface: 'asphalt',
      condition: 'dry',
      prep: 'unprepped',
    );
  }

  @override
  void dispose() {
    _trackTempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Configuration'),
        actions: [
          TextButton(
            onPressed: _saveConfig,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surface Selection
              _buildSectionTitle('Track Surface'),
              const SizedBox(height: 8),
              _buildSurfaceSelector(),
              const SizedBox(height: 24),

              // Condition Selection
              _buildSectionTitle('Track Condition'),
              const SizedBox(height: 8),
              _buildConditionSelector(),
              const SizedBox(height: 24),

              // Prep Level Selection
              _buildSectionTitle('Track Preparation'),
              const SizedBox(height: 8),
              _buildPrepSelector(),
              const SizedBox(height: 24),

              // Track Temperature
              _buildSectionTitle('Track Temperature (°C)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _trackTempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter track temperature (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _trackConfig = _trackConfig.copyWith(
                      trackTempC: double.tryParse(value),
                    );
                  });
                },
              ),
              const SizedBox(height: 32),

              // Current Configuration Summary
              _buildConfigSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSurfaceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TrackConfig.surfaces.map((surface) {
        final isSelected = _trackConfig.surface == surface;
        return FilterChip(
          label: Text(_getSurfaceDisplayName(surface)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _trackConfig = _trackConfig.copyWith(surface: surface);
              });
            }
          },
          selectedColor: StormTuneTheme.primaryBlue.withOpacity(0.2),
          checkmarkColor: StormTuneTheme.primaryBlue,
        );
      }).toList(),
    );
  }

  Widget _buildConditionSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TrackConfig.conditions.map((condition) {
        final isSelected = _trackConfig.condition == condition;
        return FilterChip(
          label: Text(_getConditionDisplayName(condition)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _trackConfig = _trackConfig.copyWith(condition: condition);
              });
            }
          },
          selectedColor: StormTuneTheme.primaryBlue.withOpacity(0.2),
          checkmarkColor: StormTuneTheme.primaryBlue,
        );
      }).toList(),
    );
  }

  Widget _buildPrepSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TrackConfig.prepLevels.map((prep) {
        final isSelected = _trackConfig.prep == prep;
        return FilterChip(
          label: Text(_getPrepDisplayName(prep)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _trackConfig = _trackConfig.copyWith(prep: prep);
              });
            }
          },
          selectedColor: StormTuneTheme.primaryBlue.withOpacity(0.2),
          checkmarkColor: StormTuneTheme.primaryBlue,
        );
      }).toList(),
    );
  }

  Widget _buildConfigSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Configuration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow('Surface', _trackConfig.surfaceDisplayName),
            _buildSummaryRow('Condition', _trackConfig.conditionDisplayName),
            _buildSummaryRow('Preparation', _trackConfig.prepDisplayName),
            if (_trackConfig.trackTempC != null)
              _buildSummaryRow('Temperature', '${_trackConfig.trackTempC!.toStringAsFixed(1)}°C'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _getSurfaceDisplayName(String surface) {
    switch (surface) {
      case 'asphalt':
        return 'Asphalt';
      case 'concrete':
        return 'Concrete';
      case 'gravel':
        return 'Gravel';
      case 'snow':
        return 'Snow';
      case 'tarmac':
        return 'Tarmac';
      default:
        return surface;
    }
  }

  String _getConditionDisplayName(String condition) {
    switch (condition) {
      case 'dry':
        return 'Dry';
      case 'damp':
        return 'Damp';
      case 'wet':
        return 'Wet';
      default:
        return condition;
    }
  }

  String _getPrepDisplayName(String prep) {
    switch (prep) {
      case 'unprepped':
        return 'Unprepped';
      case 'light':
        return 'Light Prep';
      case 'heavy':
        return 'Heavy Prep';
      default:
        return prep;
    }
  }

  void _saveConfig() {
    if (_formKey.currentState!.validate()) {
      // Save track config to app state or provider
      // For now, just navigate back
      Navigator.of(context).pop(_trackConfig);
    }
  }
}
