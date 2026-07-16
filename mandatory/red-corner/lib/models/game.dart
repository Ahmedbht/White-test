import 'package:flutter/material.dart';

class Game {
  final String id;
  final String name;
  final IconData icon;
  final String category;
  final String description;
  final Color accent;
  final double sizeGb;
  final DateTime lastPlayed;

  const Game({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.description,
    required this.accent,
    required this.sizeGb,
    required this.lastPlayed,
  });
}
