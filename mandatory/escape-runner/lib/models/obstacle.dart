import 'dart:math';
import 'package:flutter/material.dart';

enum ObstacleShape { circle, square, diamond }

class Obstacle {
  Obstacle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.shape,
  });

  double x;
  double y;
  final double size;
  final Color color;
  final ObstacleShape shape;

  static final Random _rng = Random();

  static const List<Color> _palette = [
    Color(0xFF00F0FF),
    Color(0xFFB026FF),
    Color(0xFFFF2AA8),
    Color(0xFFFFD400),
  ];

  factory Obstacle.random({required double screenWidth, required double y}) {
    final size = 28.0 + _rng.nextDouble() * 24.0;
    final maxX = (screenWidth - size).clamp(0, double.infinity).toDouble();
    return Obstacle(
      x: _rng.nextDouble() * maxX,
      y: y,
      size: size,
      color: _palette[_rng.nextInt(_palette.length)],
      shape: ObstacleShape.values[_rng.nextInt(ObstacleShape.values.length)],
    );
  }

  Rect get rect => Rect.fromLTWH(x, y, size, size);
}
