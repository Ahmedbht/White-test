import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:qr_flutter/qr_flutter.dart';

/// Renders [data] as a QR code PNG with a white background and quiet-zone
/// padding, suitable for saving or sharing (independent of any on-screen
/// preview styling).
Future<Uint8List> renderQrPng(
  String data, {
  double size = 1024,
  double padding = 64,
}) async {
  final painter = QrPainter(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.M,
    gapless: false,
    eyeStyle: const QrEyeStyle(
      eyeShape: QrEyeShape.square,
      color: ui.Color(0xFF000000),
    ),
    dataModuleStyle: const QrDataModuleStyle(
      dataModuleShape: QrDataModuleShape.square,
      color: ui.Color(0xFF000000),
    ),
  );

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, size, size),
    ui.Paint()..color = const ui.Color(0xFFFFFFFF),
  );

  final innerSize = size - padding * 2;
  canvas.save();
  canvas.translate(padding, padding);
  painter.paint(canvas, ui.Size(innerSize, innerSize));
  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
