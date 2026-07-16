import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:red_corner/main.dart';

void main() {
  testWidgets('Red Corner app launches and shows bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RedCornerApp());
    await tester.pumpAndSettle();

    expect(find.text('RED CORNER'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tapping a game card opens the detail dialog with Launch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RedCornerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crimson Siege').first);
    await tester.pumpAndSettle();

    expect(find.text('Launch'), findsOneWidget);

    await tester.tap(find.text('Launch'));
    await tester.pump();

    expect(find.textContaining('Launching Crimson Siege'), findsOneWidget);
  });
}
