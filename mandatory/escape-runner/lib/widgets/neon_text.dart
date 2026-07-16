import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  const NeonText(
    this.text, {
    super.key,
    required this.color,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.glowRadius = 14,
    this.letterSpacing,
    this.textAlign,
  });

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double glowRadius;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        shadows: [
          Shadow(color: color, blurRadius: glowRadius),
          Shadow(color: color, blurRadius: glowRadius * 2),
          Shadow(color: color.withValues(alpha: 0.8), blurRadius: glowRadius * 3.5),
        ],
      ),
    );
  }
}
