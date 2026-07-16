import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceStats {
  final String deviceModel;
  final String osLabel;
  final int? cpuCores;
  final double? ramTotalMb;
  final double? ramFreeMb;
  final double? storageTotalGb;
  final double? storageFreeGb;
  final int? batteryLevel;
  final String batteryStateLabel;

  const DeviceStats({
    required this.deviceModel,
    required this.osLabel,
    this.cpuCores,
    this.ramTotalMb,
    this.ramFreeMb,
    this.storageTotalGb,
    this.storageFreeGb,
    this.batteryLevel,
    required this.batteryStateLabel,
  });
}

class DeviceStatsService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final Battery _battery = Battery();

  Future<DeviceStats> load() async {
    final results = await Future.wait([
      _loadDeviceAndMemory(),
      _loadBattery(),
    ]);

    final deviceAndMemory = results[0] as _DeviceAndMemory;
    final battery = results[1] as _BatteryInfo;

    return DeviceStats(
      deviceModel: deviceAndMemory.model,
      osLabel: deviceAndMemory.os,
      cpuCores: deviceAndMemory.cpuCores,
      ramTotalMb: deviceAndMemory.ramTotalMb,
      ramFreeMb: deviceAndMemory.ramFreeMb,
      storageTotalGb: deviceAndMemory.storageTotalGb,
      storageFreeGb: deviceAndMemory.storageFreeGb,
      batteryLevel: battery.level,
      batteryStateLabel: battery.stateLabel,
    );
  }

  Future<_BatteryInfo> _loadBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      return _BatteryInfo(level: level, stateLabel: _batteryStateToLabel(state));
    } catch (_) {
      return const _BatteryInfo(level: null, stateLabel: 'Not available');
    }
  }

  String _batteryStateToLabel(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.connectedNotCharging:
        return 'Connected';
      case BatteryState.unknown:
        return 'Unknown';
    }
  }

  Future<_DeviceAndMemory> _loadDeviceAndMemory() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfoPlugin.webBrowserInfo;
        final deviceMemoryGb = info.deviceMemory;
        return _DeviceAndMemory(
          model: info.browserName.name,
          os: info.platform ?? 'Web',
          ramTotalMb: deviceMemoryGb != null ? deviceMemoryGb * 1024 : null,
        );
      }
      if (Platform.isWindows) {
        final info = await _deviceInfoPlugin.windowsInfo;
        final storage = await _windowsStorage();
        return _DeviceAndMemory(
          model: '${info.productName} (${info.computerName})',
          os: 'Windows ${info.displayVersion}',
          cpuCores: info.numberOfCores,
          ramTotalMb: info.systemMemoryInMegabytes.toDouble(),
          storageTotalGb: storage?.$1,
          storageFreeGb: storage?.$2,
        );
      }
      if (Platform.isAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        return _DeviceAndMemory(
          model: '${info.manufacturer} ${info.model}',
          os: 'Android ${info.version.release} (SDK ${info.version.sdkInt})',
          ramTotalMb: info.physicalRamSize.toDouble(),
          ramFreeMb: info.availableRamSize.toDouble(),
          storageTotalGb: info.totalDiskSize / (1024 * 1024 * 1024),
          storageFreeGb: info.freeDiskSize / (1024 * 1024 * 1024),
        );
      }
      if (Platform.isIOS) {
        final info = await _deviceInfoPlugin.iosInfo;
        return _DeviceAndMemory(
          model: info.modelName,
          os: 'iOS ${info.systemVersion}',
          ramTotalMb: info.physicalRamSize.toDouble(),
          ramFreeMb: info.availableRamSize.toDouble(),
          storageTotalGb: info.totalDiskSize / (1024 * 1024 * 1024),
          storageFreeGb: info.freeDiskSize / (1024 * 1024 * 1024),
        );
      }
      if (Platform.isMacOS) {
        final info = await _deviceInfoPlugin.macOsInfo;
        final storage = await _unixStorage();
        return _DeviceAndMemory(
          model: info.modelName,
          os: 'macOS ${info.osRelease}',
          cpuCores: info.activeCPUs,
          ramTotalMb: info.memorySize / (1024 * 1024),
          storageTotalGb: storage?.$1,
          storageFreeGb: storage?.$2,
        );
      }
      if (Platform.isLinux) {
        final info = await _deviceInfoPlugin.linuxInfo;
        final storage = await _unixStorage();
        return _DeviceAndMemory(
          model: info.prettyName,
          os: '${info.name} ${info.version ?? ''}'.trim(),
          storageTotalGb: storage?.$1,
          storageFreeGb: storage?.$2,
        );
      }
    } catch (_) {
      // fall through to unknown below
    }
    return const _DeviceAndMemory(model: 'Unknown device', os: 'Unknown OS');
  }

  Future<(double, double)?> _windowsStorage() async {
    try {
      final result = await Process.run('powershell', [
        '-NoProfile',
        '-NonInteractive',
        '-Command',
        'Get-CimInstance Win32_LogicalDisk -Filter "DeviceID=\'C:\'" '
            '| Select-Object Size,FreeSpace | ConvertTo-Json -Compress',
      ]);
      if (result.exitCode != 0) return null;
      final output = result.stdout.toString().trim();
      if (output.isEmpty) return null;
      final data = jsonDecode(output) as Map<String, dynamic>;
      final total = _toDouble(data['Size']);
      final free = _toDouble(data['FreeSpace']);
      if (total == null || free == null) return null;
      const gb = 1024 * 1024 * 1024;
      return (total / gb, free / gb);
    } catch (_) {
      return null;
    }
  }

  Future<(double, double)?> _unixStorage() async {
    try {
      final result = await Process.run('df', ['-k', '/']);
      if (result.exitCode != 0) return null;
      final lines = result.stdout.toString().trim().split('\n');
      if (lines.length < 2) return null;
      final parts = lines[1].trim().split(RegExp(r'\s+'));
      if (parts.length < 4) return null;
      final totalKb = double.tryParse(parts[1]);
      final availKb = double.tryParse(parts[3]);
      if (totalKb == null || availKb == null) return null;
      const kbToGb = 1024 * 1024;
      return (totalKb / kbToGb, availKb / kbToGb);
    } catch (_) {
      return null;
    }
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class _DeviceAndMemory {
  final String model;
  final String os;
  final int? cpuCores;
  final double? ramTotalMb;
  final double? ramFreeMb;
  final double? storageTotalGb;
  final double? storageFreeGb;

  const _DeviceAndMemory({
    required this.model,
    required this.os,
    this.cpuCores,
    this.ramTotalMb,
    this.ramFreeMb,
    this.storageTotalGb,
    this.storageFreeGb,
  });
}

class _BatteryInfo {
  final int? level;
  final String stateLabel;

  const _BatteryInfo({required this.level, required this.stateLabel});
}
