import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/models/car_profile.dart';
import 'package:stormtune/utils/theme.dart';
import 'dart:math';

class CarSetupScreen extends StatefulWidget {
  final CarProfile? profileToEdit;
  
  const CarSetupScreen({super.key, this.profileToEdit});

  @override
  State<CarSetupScreen> createState() => _CarSetupScreenState();
}

class _CarSetupScreenState extends State<CarSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ecuController = TextEditingController();
  final _launchRpmController = TextEditingController();
  final _baseWgdcController = TextEditingController();
  final _afrTargetController = TextEditingController();
  final _tirePressureController = TextEditingController();
  final _boostController = TextEditingController();

  String _drive = 'FWD';
  String _induction = 'turbo';
  String _fuel = 'Pump';
  String _tire = 'drag_radial';
  String _weightClass = 'mid';
  String _ignitionStrength = 'OEM';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.profileToEdit != null;
    if (_isEditing) {
      _loadProfile(widget.profileToEdit!);
    } else {
      _setDefaults();
    }
  }

  void _loadProfile(CarProfile profile) {
    _nameController.text = profile.name;
    _ecuController.text = profile.ecuBrand ?? '';
    _launchRpmController.text = profile.launchRpm.toString();
    _baseWgdcController.text = profile.baseWgdcPct?.toString() ?? '';
    _afrTargetController.text = profile.afrTargetWot?.toString() ?? '';
    _tirePressureController.text = profile.tireHotPressurePsi?.toString() ?? '';
    _boostController.text = profile.boostPsi?.toString() ?? '';
    
    _drive = profile.drive;
    _induction = profile.induction;
    _fuel = profile.fuel;
    _tire = profile.tire;
    _weightClass = profile.weightClass;
    _ignitionStrength = profile.ignitionStrength ?? 'OEM';
  }

  void _setDefaults() {
    _launchRpmController.text = '5500';
    _baseWgdcController.text = '55.0';
    _afrTargetController.text = '11.8';
    _tirePressureController.text = '16.0';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ecuController.dispose();
    _launchRpmController.dispose();
    _baseWgdcController.dispose();
    _afrTargetController.dispose();
    _tirePressureController.dispose();
    _boostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Car Profile' : 'New Car Profile'),
      ),
      body: Consumer<CarProfileProvider>(
        builder: (context, carProvider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Basic Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Profile Name',
                              hintText: 'My Race Car',
                              prefixIcon: Icon(Icons.directions_car),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Profile name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _ecuController,
                            decoration: const InputDecoration(
                              labelText: 'ECU Brand (Optional)',
                              hintText: 'Haltech, AEM, etc.',
                              prefixIcon: Icon(Icons.memory),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Drive Configuration
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Drive Configuration',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildDropdown(
                            label: 'Drive Type',
                            value: _drive,
                            items: const [
                              DropdownMenuItem(value: 'FWD', child: Text('Front Wheel Drive')),
                              DropdownMenuItem(value: 'RWD', child: Text('Rear Wheel Drive')),
                              DropdownMenuItem(value: 'AWD', child: Text('All Wheel Drive')),
                            ],
                            onChanged: (value) => setState(() => _drive = value!),
                          ),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            label: 'Induction Type',
                            value: _induction,
                            items: const [
                              DropdownMenuItem(value: 'na', child: Text('Naturally Aspirated')),
                              DropdownMenuItem(value: 'turbo', child: Text('Turbocharged')),
                              DropdownMenuItem(value: 'supercharged', child: Text('Supercharged')),
                            ],
                            onChanged: (value) => setState(() => _induction = value!),
                          ),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            label: 'Fuel Type',
                            value: _fuel,
                            items: const [
                              DropdownMenuItem(value: 'Pump', child: Text('Pump Gas')),
                              DropdownMenuItem(value: 'E85', child: Text('E85')),
                              DropdownMenuItem(value: 'Race', child: Text('Race Fuel')),
                            ],
                            onChanged: (value) => setState(() => _fuel = value!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tire and Weight
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tire & Weight',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildDropdown(
                            label: 'Tire Type',
                            value: _tire,
                            items: const [
                              DropdownMenuItem(value: 'street', child: Text('Street')),
                              DropdownMenuItem(value: 'drag_radial', child: Text('Drag Radial')),
                              DropdownMenuItem(value: 'slick', child: Text('Slick')),
                              DropdownMenuItem(value: 'semislick', child: Text('Semi-Slick')),
                              DropdownMenuItem(value: 'rally', child: Text('Rally')),
                            ],
                            onChanged: (value) => setState(() => _tire = value!),
                          ),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            label: 'Weight Class',
                            value: _weightClass,
                            items: const [
                              DropdownMenuItem(value: 'light', child: Text('Light (<3000 lbs)')),
                              DropdownMenuItem(value: 'mid', child: Text('Mid (3000-4000 lbs)')),
                              DropdownMenuItem(value: 'heavy', child: Text('Heavy (>4000 lbs)')),
                            ],
                            onChanged: (value) => setState(() => _weightClass = value!),
                          ),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            label: 'Ignition Strength',
                            value: _ignitionStrength,
                            items: const [
                              DropdownMenuItem(value: 'OEM', child: Text('OEM')),
                              DropdownMenuItem(value: 'SmartCoils', child: Text('Smart Coils')),
                              DropdownMenuItem(value: 'CDI', child: Text('CDI')),
                            ],
                            onChanged: (value) => setState(() => _ignitionStrength = value!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tuning Parameters
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tuning Parameters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: _launchRpmController,
                            decoration: const InputDecoration(
                              labelText: 'Launch RPM',
                              hintText: '5500',
                              prefixIcon: Icon(Icons.trending_up),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Launch RPM is required';
                              }
                              final rpm = int.tryParse(value);
                              if (rpm == null || rpm < 1000 || rpm > 10000) {
                                return 'Enter a valid RPM (1000-10000)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _boostController,
                            decoration: const InputDecoration(
                              labelText: 'Boost Level (PSI)',
                              hintText: '12.0',
                              prefixIcon: Icon(Icons.speed),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final boost = double.tryParse(value);
                                if (boost == null || boost < 0 || boost > 50) {
                                  return 'Enter a valid boost (0-50 PSI)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _baseWgdcController,
                            decoration: const InputDecoration(
                              labelText: 'Base Wastegate Duty Cycle (%)',
                              hintText: '55.0',
                              prefixIcon: Icon(Icons.settings),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final wgdc = double.tryParse(value);
                                if (wgdc == null || wgdc < 0 || wgdc > 100) {
                                  return 'Enter a valid duty cycle (0-100%)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _afrTargetController,
                            decoration: const InputDecoration(
                              labelText: 'AFR Target WOT',
                              hintText: '11.8',
                              prefixIcon: Icon(Icons.local_gas_station),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final afr = double.tryParse(value);
                                if (afr == null || afr < 10 || afr > 15) {
                                  return 'Enter a valid AFR (10-15)';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _tirePressureController,
                            decoration: const InputDecoration(
                              labelText: 'Tire Hot Pressure (PSI)',
                              hintText: '16.0',
                              prefixIcon: Icon(Icons.tire_repair),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final pressure = double.tryParse(value);
                                if (pressure == null || pressure < 5 || pressure > 50) {
                                  return 'Enter a valid pressure (5-50 PSI)';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: carProvider.isLoading ? null : _saveProfile,
                      icon: carProvider.isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        carProvider.isLoading 
                            ? 'Saving...' 
                            : (_isEditing ? 'Update Profile' : 'Save Profile'),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  // Error message
                  if (carProvider.errorMessage != null) ...[
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
                        carProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final carProvider = context.read<CarProfileProvider>();
      
      final profile = CarProfile(
        id: _isEditing ? widget.profileToEdit!.id : _generateId(),
        name: _nameController.text.trim(),
        drive: _drive,
        induction: _induction,
        fuel: _fuel,
        tire: _tire,
        weightClass: _weightClass,
        ignitionStrength: _ignitionStrength,
        launchRpm: int.parse(_launchRpmController.text),
        baseWgdcPct: _baseWgdcController.text.isNotEmpty 
            ? double.parse(_baseWgdcController.text) 
            : null,
        afrTargetWot: _afrTargetController.text.isNotEmpty 
            ? double.parse(_afrTargetController.text) 
            : null,
        tireHotPressurePsi: _tirePressureController.text.isNotEmpty 
            ? double.parse(_tirePressureController.text) 
            : null,
        boostPsi: _boostController.text.isNotEmpty 
            ? double.parse(_boostController.text) 
            : null,
        ecuBrand: _ecuController.text.trim().isNotEmpty 
            ? _ecuController.text.trim() 
            : null,
        createdAt: _isEditing ? widget.profileToEdit!.createdAt : DateTime.now(),
      );

      carProvider.saveProfile(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing 
                ? 'Profile updated successfully' 
                : 'Profile created successfully',
          ),
          backgroundColor: StormTuneTheme.successGreen,
        ),
      );

      Navigator.pop(context);
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
} 