enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  /// Multiplies the obstacle fall speed.
  double get speedMultiplier {
    switch (this) {
      case Difficulty.easy:
        return 0.75;
      case Difficulty.medium:
        return 1.0;
      case Difficulty.hard:
        return 1.4;
    }
  }

  /// Multiplies the base spawn interval; lower means obstacles spawn more often.
  double get spawnMultiplier {
    switch (this) {
      case Difficulty.easy:
        return 1.35;
      case Difficulty.medium:
        return 1.0;
      case Difficulty.hard:
        return 0.7;
    }
  }

  static Difficulty fromName(String? name) {
    return Difficulty.values.firstWhere(
      (d) => d.name == name,
      orElse: () => Difficulty.medium,
    );
  }
}
