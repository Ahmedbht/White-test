import 'dart:math';
import 'package:flutter/material.dart';

/// A falling shield pickup that grants the player one free hit.
class PowerUp {
  PowerUp({required this.x, required this.y, required this.size});

  double x;
  double y;
  final double size;

  static final Random _rng = Random();

  factory PowerUp.random({required double screenWidth, required double y}) {
    const size = 36.0;
    final maxX = (screenWidth - size).clamp(0, double.infinity).toDouble();
    return PowerUp(x: _rng.nextDouble() * maxX, y: y, size: size);
  }

  Rect get rect => Rect.fromLTWH(x, y, size, size);
}
