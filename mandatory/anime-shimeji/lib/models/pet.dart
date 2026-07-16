import 'package:flutter/material.dart';

class Pet {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const Pet({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });
}

const List<Pet> kPets = [
  Pet(id: 'cat', name: 'Mochi Cat', emoji: '🐱', color: Color(0xFFFFC1E0)),
  Pet(id: 'bunny', name: 'Bunbun', emoji: '🐰', color: Color(0xFFE0C3FC)),
  Pet(id: 'bear', name: 'Honey Bear', emoji: '🐻', color: Color(0xFFFFE0B2)),
  Pet(id: 'panda', name: 'Pan Pan', emoji: '🐼', color: Color(0xFFC8E6FF)),
  Pet(id: 'hamster', name: 'Hammy', emoji: '🐹', color: Color(0xFFFFF3B0)),
];
