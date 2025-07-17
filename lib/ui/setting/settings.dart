import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_offline_desktop/l10n/l10n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(10),

          // Dark Mode Toggle
          SwitchListTile(
            title: Text(context.l10n.dark_mode),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            secondary: const Icon(Icons.dark_mode),
          ),

          const Divider(height: 32),

          Text(
            context.l10n.other_settings,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(10),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.l10n.about),
            onTap: () {
              // Show about app info
              showAboutDialog(
                context: context,
                applicationName: 'POS System',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.store),
                children: [
                  const Text('This is a simple POS system built with Flutter.'),
                ],
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(height: 32),
          Center(
            child: Text(
              "${context.l10n.version} 1.0.0",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
