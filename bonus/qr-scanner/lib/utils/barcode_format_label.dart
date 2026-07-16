import 'package:mobile_scanner/mobile_scanner.dart';

String barcodeFormatLabel(BarcodeFormat format) {
  switch (format) {
    case BarcodeFormat.qrCode:
      return 'QR Code';
    case BarcodeFormat.aztec:
      return 'Aztec';
    case BarcodeFormat.codabar:
      return 'Codabar';
    case BarcodeFormat.code39:
      return 'Code 39';
    case BarcodeFormat.code93:
      return 'Code 93';
    case BarcodeFormat.code128:
      return 'Code 128';
    case BarcodeFormat.dataMatrix:
      return 'Data Matrix';
    case BarcodeFormat.ean8:
      return 'EAN-8';
    case BarcodeFormat.ean13:
      return 'EAN-13';
    case BarcodeFormat.itf14:
      return 'ITF';
    // ignore: deprecated_member_use
    case BarcodeFormat.itf:
      return 'ITF';
    case BarcodeFormat.itf2of5:
    case BarcodeFormat.itf2of5WithChecksum:
      return 'ITF';
    case BarcodeFormat.pdf417:
      return 'PDF417';
    case BarcodeFormat.upcA:
      return 'UPC-A';
    case BarcodeFormat.upcE:
      return 'UPC-E';
    case BarcodeFormat.all:
    case BarcodeFormat.unknown:
      return 'Barcode';
  }
}
