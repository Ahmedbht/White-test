import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/background_theme.dart';

class AppState extends ChangeNotifier {
  Pet _selectedPet = kPets.first;
  double _petSize = 140;
  BackgroundTheme _backgroundTheme = kBackgroundThemes.first;
  bool _soundEnabled = true;
  double _happiness = 70;

  Timer? _decayTimer;

  AppState() {
    _decayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _happiness = (_happiness - 2).clamp(0, 100);
      notifyListeners();
    });
  }

  Pet get selectedPet => _selectedPet;
  double get petSize => _petSize;
  BackgroundTheme get backgroundTheme => _backgroundTheme;
  bool get soundEnabled => _soundEnabled;
  double get happiness => _happiness;

  void selectPet(Pet pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  void setPetSize(double size) {
    _petSize = size;
    notifyListeners();
  }

  void setBackgroundTheme(BackgroundTheme theme) {
    _backgroundTheme = theme;
    notifyListeners();
  }

  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  void pet() {
    _happiness = (_happiness + 8).clamp(0, 100);
    notifyListeners();
  }

  @override
  void dispose() {
    _decayTimer?.cancel();
    super.dispose();
  }
}
