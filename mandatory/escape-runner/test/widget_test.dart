import 'package:flutter_test/flutter_test.dart';

import 'package:escape_runner/main.dart';

void main() {
  testWidgets('Home screen shows title, start button and high score', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EscapeRunnerApp());
    await tester.pumpAndSettle();

    expect(find.text('ESCAPE'), findsOneWidget);
    expect(find.text('RUNNER'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('HIGH SCORE'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Tapping Start navigates to the game screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EscapeRunnerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('START'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('SCORE'), findsWidgets);
  });
}
