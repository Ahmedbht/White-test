import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EscapeRunnerApp());
}

class EscapeRunnerApp extends StatelessWidget {
  const EscapeRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escape Runner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNeonTheme,
      home: const HomeScreen(),
    );
  }
}
