import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/customize_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_selector_screen.dart';
import 'screens/stats_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(const AnimeShimejiApp());
}

class AnimeShimejiApp extends StatelessWidget {
  const AnimeShimejiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Anime Shimeji',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE0559A),
            brightness: Brightness.light,
            primary: const Color(0xFFE0559A),
            secondary: const Color(0xFFB98CE0),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF0F7),
          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: const Color(0xFF6B4A75),
                displayColor: const Color(0xFF6B4A75),
              ),
        ),
        home: const RootShell(),
      ),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    PetSelectorScreen(),
    CustomizeScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white.withValues(alpha: 0.92),
        indicatorColor: const Color(0xFFFFC1E0),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Pets',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Customize',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
