import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:uuid/uuid.dart';

import '../models/scan_record.dart';
import '../services/history_service.dart';
import '../utils/barcode_format_label.dart';
import '../widgets/scan_result_sheet.dart';
import '../widgets/scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, this.onScanSaved});

  final VoidCallback? onScanSaved;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: false,
  );
  final _uuid = const Uuid();

  bool _isProcessingResult = false;
  ph.PermissionStatus _permissionStatus = ph.PermissionStatus.denied;
  bool _checkingPermission = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final status = await ph.Permission.camera.status;
    if (!mounted) return;
    setState(() {
      _permissionStatus = status;
      _checkingPermission = false;
    });
    if (status.isGranted) {
      unawaited(_controller.start());
    }
  }

  Future<void> _requestPermission() async {
    final status = await ph.Permission.camera.request();
    if (!mounted) return;
    setState(() => _permissionStatus = status);
    if (status.isGranted) {
      unawaited(_controller.start());
    }
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessingResult) return;
    final barcode =
        capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final value = barcode?.rawValue ?? barcode?.displayValue;
    if (barcode == null || value == null || value.isEmpty) return;

    _isProcessingResult = true;
    await _controller.stop();

    final record = ScanRecord(
      id: _uuid.v4(),
      content: value,
      format: barcodeFormatLabel(barcode.format),
      timestamp: DateTime.now(),
    );
    await HistoryService.instance.addScan(record);
    widget.onScanSaved?.call();

    if (!mounted) return;
    await showScanResultSheet(context, record);

    if (!mounted) return;
    _isProcessingResult = false;
    if (_permissionStatus.isGranted) {
      unawaited(_controller.start());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: [
          if (_permissionStatus.isGranted) ...[
            ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, child) {
                final torchOn = state.torchState == TorchState.on;
                return IconButton(
                  onPressed: () => _controller.toggleTorch(),
                  icon: Icon(torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded),
                  tooltip: 'Toggle flash',
                );
              },
            ),
            IconButton(
              onPressed: () => _controller.switchCamera(),
              icon: const Icon(Icons.cameraswitch_rounded),
              tooltip: 'Switch camera',
            ),
          ],
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_permissionStatus.isGranted) {
      return _PermissionRequest(
        isPermanentlyDenied: _permissionStatus.isPermanentlyDenied,
        onRequest: _requestPermission,
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _handleDetection,
          errorBuilder: (context, error) => _ScannerError(error: error),
          overlayBuilder: (context, constraints) => ScannerOverlay(
            size: constraints.biggest,
            borderColor: scheme.primary,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Align the code within the frame',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PermissionRequest extends StatelessWidget {
  const _PermissionRequest({
    required this.isPermanentlyDenied,
    required this.onRequest,
  });

  final bool isPermanentlyDenied;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_camera_outlined, size: 72, color: scheme.primary),
            const SizedBox(height: 20),
            Text(
              'Camera access needed',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isPermanentlyDenied
                  ? 'Camera permission was denied. Enable it in system settings to scan codes.'
                  : 'QR Scanner needs camera access to scan QR codes and barcodes.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isPermanentlyDenied ? ph.openAppSettings : onRequest,
              icon: Icon(isPermanentlyDenied ? Icons.settings_rounded : Icons.camera_alt_rounded),
              label: Text(isPermanentlyDenied ? 'Open Settings' : 'Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                error.errorCode.message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
