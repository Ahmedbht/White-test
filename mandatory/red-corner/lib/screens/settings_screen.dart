import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;
    final mutedColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.5);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Appearance', color: mutedColor),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  ),
                  title: const Text('Dark theme'),
                  subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
                  value: isDark,
                  onChanged: (value) {
                    onThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Notifications', color: mutedColor),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active_rounded),
              title: const Text('Game alerts'),
              subtitle: const Text('Updates, friend activity, and offers'),
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('About', color: mutedColor),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.sports_esports_rounded),
                  title: Text('Red Corner'),
                  subtitle: Text('Your games, your corner.'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('Built with Flutter'),
                  subtitle: Text('Material 3 · Dark gaming UI', style: TextStyle(color: mutedColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _SectionLabel(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: color,
        ),
      ),
    );
  }
}
