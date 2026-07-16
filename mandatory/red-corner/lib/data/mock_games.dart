import 'package:flutter/material.dart';
import '../models/game.dart';

final List<Game> mockGames = [
  Game(
    id: 'g1',
    name: 'Crimson Siege',
    icon: Icons.local_fire_department,
    category: 'FPS',
    description:
        'Storm enemy fortresses in this fast-paced tactical shooter. '
        'Squad up, breach, and clear objectives across 12 war-torn maps.',
    accent: const Color(0xFFE10600),
    sizeGb: 42.3,
    lastPlayed: DateTime(2026, 7, 14),
  ),
  Game(
    id: 'g2',
    name: 'Neon Drift',
    icon: Icons.sports_motorsports,
    category: 'Racing',
    description:
        'Arcade racing through a synthwave-soaked city. Customize your ride, '
        'drift through neon-lit streets, and climb the global leaderboard.',
    accent: const Color(0xFF00E5FF),
    sizeGb: 18.7,
    lastPlayed: DateTime(2026, 7, 10),
  ),
  Game(
    id: 'g3',
    name: 'Ironvale',
    icon: Icons.shield,
    category: 'RPG',
    description:
        'An open-world fantasy epic. Forge alliances, master elemental magic, '
        'and decide the fate of the shattered kingdom of Ironvale.',
    accent: const Color(0xFFFFB300),
    sizeGb: 87.1,
    lastPlayed: DateTime(2026, 6, 30),
  ),
  Game(
    id: 'g4',
    name: 'Void Runner',
    icon: Icons.rocket_launch,
    category: 'Platformer',
    description:
        'Sprint, wall-jump, and phase through dimensions in this precision '
        'platformer set aboard a dying space station.',
    accent: const Color(0xFF7C4DFF),
    sizeGb: 6.4,
    lastPlayed: DateTime(2026, 7, 15),
  ),
  Game(
    id: 'g5',
    name: 'Bastion Command',
    icon: Icons.castle,
    category: 'Strategy',
    description:
        'Build your empire, manage resources, and out-maneuver rival '
        'commanders in real-time siege battles.',
    accent: const Color(0xFF00C853),
    sizeGb: 24.9,
    lastPlayed: DateTime(2026, 7, 1),
  ),
  Game(
    id: 'g6',
    name: 'Shadow Ledger',
    icon: Icons.visibility_off,
    category: 'Stealth',
    description:
        'Infiltrate, hack, and vanish. A stealth-thriller about a rogue '
        'operative unraveling a global conspiracy from the shadows.',
    accent: const Color(0xFF9E9E9E),
    sizeGb: 33.6,
    lastPlayed: DateTime(2026, 7, 12),
  ),
  Game(
    id: 'g7',
    name: 'Pixel Brawlers',
    icon: Icons.sports_kabaddi,
    category: 'Fighting',
    description:
        'Retro-styled couch fighter with 24 unique characters, rollback '
        'netcode, and a wild roster of stages.',
    accent: const Color(0xFFFF6D00),
    sizeGb: 4.2,
    lastPlayed: DateTime(2026, 6, 20),
  ),
  Game(
    id: 'g8',
    name: 'Frostbound',
    icon: Icons.ac_unit,
    category: 'Survival',
    description:
        'Survive a brutal eternal winter. Scavenge, craft, and defend your '
        'settlement against the things that hunt in the blizzard.',
    accent: const Color(0xFF448AFF),
    sizeGb: 55.0,
    lastPlayed: DateTime(2026, 7, 5),
  ),
];
