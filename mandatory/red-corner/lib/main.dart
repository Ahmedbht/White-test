import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/library_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const RedCornerApp());
}

class RedCornerApp extends StatefulWidget {
  const RedCornerApp({super.key});

  @override
  State<RedCornerApp> createState() => _RedCornerAppState();
}

class _RedCornerAppState extends State<RedCornerApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _notificationsEnabled = true;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _setNotificationsEnabled(bool enabled) {
    setState(() => _notificationsEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Corner',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: MainShell(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: _setNotificationsEnabled,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const MainShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const DashboardScreen();
      case 2:
        return const LibraryScreen();
      default:
        return SettingsScreen(
          themeMode: widget.themeMode,
          onThemeModeChanged: widget.onThemeModeChanged,
          notificationsEnabled: widget.notificationsEnabled,
          onNotificationsChanged: widget.onNotificationsChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(_index),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.videogame_asset_outlined),
            selectedIcon: Icon(Icons.videogame_asset),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
