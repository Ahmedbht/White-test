import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final score = await StorageService.instance.getHighScore();
    if (!mounted) return;
    setState(() => _highScore = score);
  }

  Future<void> _startGame() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
    _loadHighScore();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, color: NeonColors.pink, size: 56),
                const SizedBox(height: 8),
                const NeonText(
                  'ESCAPE',
                  color: NeonColors.cyan,
                  fontSize: 46,
                  letterSpacing: 8,
                ),
                const NeonText(
                  'RUNNER',
                  color: NeonColors.purple,
                  fontSize: 38,
                  letterSpacing: 10,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  decoration: BoxDecoration(
                    border: Border.all(color: NeonColors.pink.withValues(alpha: 0.6)),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'HIGH SCORE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 3,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      NeonText('$_highScore', color: NeonColors.pink, fontSize: 32),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                NeonButton(
                  label: 'START',
                  icon: Icons.play_arrow_rounded,
                  color: NeonColors.cyan,
                  width: double.infinity,
                  onPressed: _startGame,
                ),
                const SizedBox(height: 16),
                NeonButton(
                  label: 'SETTINGS',
                  icon: Icons.settings_rounded,
                  color: NeonColors.purple,
                  width: double.infinity,
                  onPressed: _openSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
