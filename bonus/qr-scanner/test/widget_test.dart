import 'package:flutter_test/flutter_test.dart';

import 'package:qr_scanner/main.dart';

void main() {
  testWidgets('App shows the bottom navigation destinations', (tester) async {
    await tester.pumpWidget(const QrScannerApp());
    await tester.pump();

    expect(find.text('Scan'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Generate'), findsWidgets);
  });
}
