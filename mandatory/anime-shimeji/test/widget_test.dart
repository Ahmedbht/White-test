import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anime_shimeji/main.dart';

void main() {
  testWidgets('App loads home screen with nav bar', (WidgetTester tester) async {
    await tester.pumpWidget(const AnimeShimejiApp());
    await tester.pump();

    expect(find.text('Mochi Cat'), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Pets'), findsOneWidget);
    expect(find.text('Customize'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });

  testWidgets('Navigating to pet selector shows grid of pets', (WidgetTester tester) async {
    await tester.pumpWidget(const AnimeShimejiApp());
    await tester.pump();

    await tester.tap(find.text('Pets'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Choose your companion'), findsOneWidget);
    expect(find.text('Bunbun'), findsOneWidget);
  });
}
