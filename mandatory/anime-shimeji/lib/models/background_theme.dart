import 'package:flutter/material.dart';

class BackgroundTheme {
  final String name;
  final Color top;
  final Color bottom;

  const BackgroundTheme({
    required this.name,
    required this.top,
    required this.bottom,
  });

  Gradient get gradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [top, bottom],
      );
}

const List<BackgroundTheme> kBackgroundThemes = [
  BackgroundTheme(
    name: 'Sakura Pink',
    top: Color(0xFFFFE4F1),
    bottom: Color(0xFFFFC1E0),
  ),
  BackgroundTheme(
    name: 'Lavender Dream',
    top: Color(0xFFF0E4FF),
    bottom: Color(0xFFE0C3FC),
  ),
  BackgroundTheme(
    name: 'Minty Fresh',
    top: Color(0xFFE0FFF4),
    bottom: Color(0xFFC3FCEA),
  ),
  BackgroundTheme(
    name: 'Peach Fuzz',
    top: Color(0xFFFFF0E0),
    bottom: Color(0xFFFFDCC3),
  ),
  BackgroundTheme(
    name: 'Sky Milk',
    top: Color(0xFFE4F1FF),
    bottom: Color(0xFFC3E0FC),
  ),
];
