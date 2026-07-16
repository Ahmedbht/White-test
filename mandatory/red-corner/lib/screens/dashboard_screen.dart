import 'package:flutter/material.dart';
import '../services/device_stats_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _service = DeviceStatsService();
  Future<DeviceStats>? _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _future = _service.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'DASHBOARD',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh stats',
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<DeviceStats>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 12),
                          const Text('Could not read device stats'),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _refresh,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final stats = snapshot.data!;
                return _DashboardContent(stats: stats);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DeviceStats stats;

  const _DashboardContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final batteryLevel = stats.batteryLevel;
    final ramTotal = stats.ramTotalMb;
    final ramFree = stats.ramFreeMb;
    final storageTotal = stats.storageTotalGb;
    final storageFree = stats.storageFreeGb;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.15,
          children: [
            _StatCard(
              icon: Icons.battery_charging_full_rounded,
              label: 'Battery',
              value: batteryLevel != null ? '$batteryLevel%' : 'N/A',
              subtitle: stats.batteryStateLabel,
              progress: batteryLevel != null ? batteryLevel / 100 : null,
              color: const Color(0xFF00C853),
            ),
            _StatCard(
              icon: Icons.memory_rounded,
              label: 'RAM',
              value: ramTotal != null
                  ? '${(ramTotal / 1024).toStringAsFixed(1)} GB'
                  : 'N/A',
              subtitle: ramFree != null
                  ? '${(ramFree / 1024).toStringAsFixed(1)} GB free'
                  : (ramTotal != null ? 'Total installed' : 'Not available'),
              progress: (ramTotal != null && ramFree != null)
                  ? 1 - (ramFree / ramTotal)
                  : null,
              color: const Color(0xFF2979FF),
            ),
            _StatCard(
              icon: Icons.storage_rounded,
              label: 'Storage',
              value: storageTotal != null
                  ? '${storageTotal.toStringAsFixed(0)} GB'
                  : 'N/A',
              subtitle: storageFree != null
                  ? '${storageFree.toStringAsFixed(1)} GB free'
                  : 'Not available',
              progress: (storageTotal != null && storageFree != null)
                  ? 1 - (storageFree / storageTotal)
                  : null,
              color: const Color(0xFFFFAB00),
            ),
            _StatCard(
              icon: Icons.developer_board_rounded,
              label: 'CPU Cores',
              value: stats.cpuCores != null ? '${stats.cpuCores}' : 'N/A',
              subtitle: 'Logical processors',
              color: const Color(0xFFE10600),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.smartphone_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Device',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _InfoRow(label: 'Model', value: stats.deviceModel),
                const Divider(height: 24),
                _InfoRow(label: 'OS', value: stats.osLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final double? progress;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress!.clamp(0, 1),
                  minHeight: 5,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
