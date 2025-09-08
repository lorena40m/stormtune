import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stormtune/providers/car_profile_provider.dart';
import 'package:stormtune/models/car_profile.dart';
import 'package:stormtune/screens/car_setup_screen.dart';
import 'package:stormtune/utils/theme.dart';
import 'package:intl/intl.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNewProfile(context),
          ),
        ],
      ),
      body: Consumer<CarProfileProvider>(
        builder: (context, carProvider, child) {
          if (carProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (carProvider.profiles.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: carProvider.profiles.length,
            itemBuilder: (context, index) {
              final profile = carProvider.profiles[index];
              final isSelected = carProvider.selectedProfile?.id == profile.id;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: isSelected 
                        ? StormTuneTheme.primaryRed 
                        : StormTuneTheme.primaryBlue,
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildProfileSpecs(profile),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${DateFormat('MMM dd, yyyy').format(profile.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: StormTuneTheme.successGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Selected',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) => _handleMenuAction(context, value, profile),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'select',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle),
                                SizedBox(width: 8),
                                Text('Select'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _selectProfile(context, profile),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Car Profiles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first car profile to get started',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _createNewProfile(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSpecs(CarProfile profile) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildSpecChip('${profile.drive}', StormTuneTheme.primaryBlue),
        _buildSpecChip('${profile.induction.toUpperCase()}', StormTuneTheme.accentOrange),
        _buildSpecChip(profile.fuel, StormTuneTheme.successGreen),
        _buildSpecChip(_formatTireType(profile.tire), StormTuneTheme.darkGrey),
        if (profile.boostPsi != null)
          _buildSpecChip('${profile.boostPsi!.toStringAsFixed(1)} PSI', StormTuneTheme.warningYellow),
      ],
    );
  }

  Widget _buildSpecChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
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

  void _createNewProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarSetupScreen(),
      ),
    );
  }

  void _selectProfile(BuildContext context, CarProfile profile) {
    context.read<CarProfileProvider>().selectProfileByObject(profile);
    Navigator.pop(context);
  }

  void _handleMenuAction(BuildContext context, String action, CarProfile profile) {
    switch (action) {
      case 'select':
        _selectProfile(context, profile);
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarSetupScreen(profileToEdit: profile),
          ),
        );
        break;
      case 'delete':
        _showDeleteDialog(context, profile);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context, CarProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete "${profile.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CarProfileProvider>().deleteProfile(profile.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 