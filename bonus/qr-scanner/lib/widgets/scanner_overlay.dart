import 'package:flutter/material.dart';

/// Computes the centered square scan window for a given layout [size].
Rect scanWindowFor(Size size) {
  final dimension = size.shortestSide * 0.7;
  return Rect.fromCenter(
    center: size.center(Offset.zero),
    width: dimension,
    height: dimension,
  );
}

/// Paints a dimmed scrim with a clear rounded-square cutout and corner
/// brackets, used as the [MobileScanner.overlayBuilder] output.
class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({
    super.key,
    required this.size,
    required this.borderColor,
  });

  final Size size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final cutout = scanWindowFor(size);
    return IgnorePointer(
      child: CustomPaint(
        size: size,
        painter: _ScannerOverlayPainter(cutout: cutout, borderColor: borderColor),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({required this.cutout, required this.borderColor});

  final Rect cutout;
  final Color borderColor;

  static const double _radius = 24;
  static const double _bracketLength = 32;
  static const double _bracketWidth = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(_radius)));

    final scrimPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawPath(scrimPath, Paint()..color = Colors.black.withValues(alpha: 0.55));
    canvas.restore();

    final bracketPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _bracketWidth
      ..strokeCap = StrokeCap.round;

    void drawCorner(Offset corner, double dx, double dy) {
      final path = Path()
        ..moveTo(corner.dx, corner.dy + dy * _bracketLength)
        ..lineTo(corner.dx, corner.dy)
        ..lineTo(corner.dx + dx * _bracketLength, corner.dy);
      canvas.drawPath(path, bracketPaint);
    }

    final tl = Offset(cutout.left, cutout.top);
    final tr = Offset(cutout.right, cutout.top);
    final bl = Offset(cutout.left, cutout.bottom);
    final br = Offset(cutout.right, cutout.bottom);

    drawCorner(tl, 1, 1);
    drawCorner(tr, -1, 1);
    drawCorner(bl, 1, -1);
    drawCorner(br, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cutout != cutout || oldDelegate.borderColor != borderColor;
  }
}
