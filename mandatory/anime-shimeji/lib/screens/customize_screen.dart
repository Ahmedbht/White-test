import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/background_theme.dart';
import '../state/app_state.dart';
import '../widgets/pet_avatar.dart';

class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return DecoratedBox(
      decoration: BoxDecoration(gradient: appState.backgroundTheme.gradient),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Customize',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B4A75),
                  ),
            ),
            const SizedBox(height: 20),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PetAvatar(pet: appState.selectedPet, size: appState.petSize),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.photo_size_select_small,
                          color: Color(0xFF8A6D96)),
                      const SizedBox(width: 8),
                      const Text(
                        'Pet size',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B4A75),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${appState.petSize.round()} px',
                        style: const TextStyle(color: Color(0xFF8A6D96)),
                      ),
                    ],
                  ),
                  Slider(
                    value: appState.petSize,
                    min: 80,
                    max: 220,
                    divisions: 14,
                    activeColor: const Color(0xFFE0559A),
                    onChanged: appState.setPetSize,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.palette_outlined, color: Color(0xFF8A6D96)),
                      SizedBox(width: 8),
                      Text(
                        'Background theme',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B4A75),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: kBackgroundThemes.map((theme) {
                      final isSelected =
                          theme.name == appState.backgroundTheme.name;
                      return GestureDetector(
                        onTap: () => appState.setBackgroundTheme(theme),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: theme.gradient,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE0559A)
                                      : Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.bottom.withValues(alpha: 0.6),
                                    blurRadius: isSelected ? 12 : 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 68,
                              child: Text(
                                theme.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8A6D96),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Row(
                children: [
                  const Icon(Icons.volume_up_rounded, color: Color(0xFF8A6D96)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Pet sounds & haptics',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B4A75),
                      ),
                    ),
                  ),
                  Switch(
                    value: appState.soundEnabled,
                    activeThumbColor: const Color(0xFFE0559A),
                    onChanged: appState.toggleSound,
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

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
