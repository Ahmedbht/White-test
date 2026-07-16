import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';
import 'game_screen.dart';
import 'home_screen.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({
    super.key,
    required this.score,
    required this.isNewHighScore,
  });

  final int score;
  final bool isNewHighScore;

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
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
                const NeonText(
                  'GAME OVER',
                  color: NeonColors.danger,
                  fontSize: 34,
                  letterSpacing: 4,
                ),
                const SizedBox(height: 32),
                Text(
                  'SCORE',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 3,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                NeonText('${widget.score}', color: NeonColors.cyan, fontSize: 56),
                const SizedBox(height: 20),
                if (widget.isNewHighScore)
                  const NeonText(
                    'NEW HIGH SCORE!',
                    color: NeonColors.pink,
                    fontSize: 16,
                    letterSpacing: 2,
                  )
                else
                  Column(
                    children: [
                      Text(
                        'HIGH SCORE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          letterSpacing: 3,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      NeonText('$_highScore', color: NeonColors.purple, fontSize: 24),
                    ],
                  ),
                const SizedBox(height: 56),
                NeonButton(
                  label: 'PLAY AGAIN',
                  icon: Icons.replay_rounded,
                  color: NeonColors.cyan,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                NeonButton(
                  label: 'MENU',
                  icon: Icons.home_rounded,
                  color: NeonColors.purple,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
