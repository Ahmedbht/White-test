import 'package:flutter/material.dart';
import '../models/pet.dart';

/// A cute rounded body with two ears and an emoji face.
class PetAvatar extends StatelessWidget {
  final Pet pet;
  final double size;
  final bool showCheeks;

  const PetAvatar({
    super.key,
    required this.pet,
    required this.size,
    this.showCheeks = true,
  });

  @override
  Widget build(BuildContext context) {
    final earSize = size * 0.32;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Ears
          Positioned(
            top: -earSize * 0.28,
            left: size * 0.02,
            child: _Ear(color: pet.color, size: earSize),
          ),
          Positioned(
            top: -earSize * 0.28,
            right: size * 0.02,
            child: _Ear(color: pet.color, size: earSize),
          ),
          // Body
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pet.color,
              boxShadow: [
                BoxShadow(
                  color: pet.color.withValues(alpha: 0.55),
                  blurRadius: size * 0.18,
                  offset: Offset(0, size * 0.06),
                ),
              ],
            ),
          ),
          // Cheeks
          if (showCheeks) ...[
            Positioned(
              left: size * 0.1,
              top: size * 0.58,
              child: _Cheek(size: size * 0.16),
            ),
            Positioned(
              right: size * 0.1,
              top: size * 0.58,
              child: _Cheek(size: size * 0.16),
            ),
          ],
          // Face
          Text(pet.emoji, style: TextStyle(fontSize: size * 0.5)),
        ],
      ),
    );
  }
}

class _Ear extends StatelessWidget {
  final Color color;
  final double size;
  const _Ear({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _Cheek extends StatelessWidget {
  final double size;
  const _Cheek({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink.withValues(alpha: 0.35),
      ),
    );
  }
}
