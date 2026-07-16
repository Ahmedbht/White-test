import 'package:flutter/material.dart';

import '../models/difficulty.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/neon_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  Difficulty _difficulty = Difficulty.medium;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sound = await StorageService.instance.getSoundEnabled();
    final difficultyName = await StorageService.instance.getDifficulty();
    if (!mounted) return;
    setState(() {
      _soundEnabled = sound;
      _difficulty = DifficultyX.fromName(difficultyName);
      _loading = false;
    });
  }

  BoxDecoration _panelDecoration(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: Colors.black.withValues(alpha: 0.4),
      border: Border.all(color: color.withValues(alpha: 0.45)),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white54,
        letterSpacing: 3,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      appBar: AppBar(
        title: const NeonText(
          'SETTINGS',
          color: NeonColors.cyan,
          fontSize: 20,
          letterSpacing: 4,
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: NeonColors.cyan),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('SOUND'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: _panelDecoration(NeonColors.cyan),
                    child: SwitchListTile(
                      title: const Text(
                        'Sound Effects',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() => _soundEnabled = value);
                        StorageService.instance.setSoundEnabled(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  _sectionLabel('DIFFICULTY'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: _panelDecoration(NeonColors.purple),
                    child: Column(
                      children: Difficulty.values.map((d) {
                        final selected = d == _difficulty;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() => _difficulty = d);
                              StorageService.instance.setDifficulty(d.name);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selected
                                    ? NeonColors.purple.withValues(alpha: 0.22)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? NeonColors.purple
                                      : Colors.white24,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: selected
                                        ? NeonColors.purple
                                        : Colors.white38,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    d.label,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 16,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
