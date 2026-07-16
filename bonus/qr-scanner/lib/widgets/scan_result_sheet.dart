import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_record.dart';

Future<void> showScanResultSheet(
  BuildContext context,
  ScanRecord record, {
  VoidCallback? onDelete,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => ScanResultSheet(record: record, onDelete: onDelete),
  );
}

class ScanResultSheet extends StatelessWidget {
  const ScanResultSheet({super.key, required this.record, this.onDelete});

  final ScanRecord record;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isUrl = record.isUrl;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isUrl ? Icons.link_rounded : Icons.qr_code_rounded,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(record.format),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: scheme.primaryContainer,
                  side: BorderSide.none,
                  labelStyle: TextStyle(color: scheme.onPrimaryContainer),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM d, y • h:mm a').format(record.timestamp),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                record.content,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: record.content),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy'),
                  ),
                ),
                if (isUrl) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => _openLink(context, record.content),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Open'),
                    ),
                  ),
                ],
              ],
            ),
            if (onDelete != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDelete?.call();
                  },
                  icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
                  label: Text('Delete', style: TextStyle(color: scheme.error)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openLink(BuildContext context, String content) async {
    final uri = Uri.tryParse(content);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }
}
