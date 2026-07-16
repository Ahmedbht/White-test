import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] for local, backend-free persistence
/// of the high score and user settings.
class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const _highScoreKey = 'high_score';
  static const _soundEnabledKey = 'sound_enabled';
  static const _difficultyKey = 'difficulty';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  /// Saves [score] as the new high score if it beats the current one.
  /// Returns true if a new high score was set.
  Future<bool> submitScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_highScoreKey) ?? 0;
    if (score > current) {
      await prefs.setInt(_highScoreKey, score);
      return true;
    }
    return false;
  }

  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  Future<String> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_difficultyKey) ?? 'medium';
  }

  Future<void> setDifficulty(String difficultyName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficultyName);
  }
}
