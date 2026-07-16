import 'package:flutter/material.dart';

class NeonButton extends StatelessWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF00F0FF),
    this.width,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final double? width;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.black.withValues(alpha: 0.5),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 16, spreadRadius: 1),
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 2),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
