import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/pet_avatar.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String _moodLabel(double happiness) {
    if (happiness >= 80) return 'Ecstatic!';
    if (happiness >= 55) return 'Happy';
    if (happiness >= 30) return 'Okay';
    if (happiness >= 10) return 'Lonely';
    return 'Needs love!';
  }

  String _moodEmoji(double happiness) {
    if (happiness >= 80) return '✨';
    if (happiness >= 55) return '💕';
    if (happiness >= 30) return '🙂';
    if (happiness >= 10) return '😢';
    return '💔';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final happiness = appState.happiness;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: appState.backgroundTheme.gradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Happiness Stats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4A75),
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  PetAvatar(pet: appState.selectedPet, size: 96),
                  const SizedBox(height: 16),
                  Text(
                    '${_moodEmoji(happiness)}  ${_moodLabel(happiness)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4A75),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: happiness / 100),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 22,
                        backgroundColor: Colors.white,
                        color: const Color(0xFFE0559A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${happiness.round()} / 100',
                    style: const TextStyle(color: Color(0xFF8A6D96)),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      appState.pet();
                      if (appState.soundEnabled) {
                        HapticFeedback.lightImpact();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE0559A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.favorite),
                    label: const Text('Give some love'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF8A6D96)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Happiness slowly fades over time — tap or pet your '
                      'companion on the Home screen to keep them glowing!',
                      style: TextStyle(color: Color(0xFF6B4A75)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
