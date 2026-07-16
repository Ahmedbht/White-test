import 'package:flutter/material.dart';

import 'screens/generate_screen.dart';
import 'screens/history_screen.dart';
import 'screens/scanner_screen.dart';
import 'theme.dart';

void main() {
  runApp(const QrScannerApp());
}

class QrScannerApp extends StatelessWidget {
  const QrScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  // Bump to force History to rebuild (and reload) when a new scan is saved.
  int _historyRefreshTick = 0;

  void _goToHistory() {
    setState(() {
      _historyRefreshTick++;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ScannerScreen(onScanSaved: _goToHistory),
      HistoryScreen(key: ValueKey(_historyRefreshTick)),
      const GenerateScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_2_outlined),
            selectedIcon: Icon(Icons.qr_code_2),
            label: 'Generate',
          ),
        ],
      ),
    );
  }
}
