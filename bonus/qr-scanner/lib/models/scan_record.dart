import 'dart:convert';

class ScanRecord {
  final String id;
  final String content;
  final String format;
  final DateTime timestamp;

  ScanRecord({
    required this.id,
    required this.content,
    required this.format,
    required this.timestamp,
  });

  bool get isUrl {
    final uri = Uri.tryParse(content);
    return uri != null &&
        (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'format': format,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ScanRecord.fromJson(Map<String, dynamic> json) => ScanRecord(
        id: json['id'] as String,
        content: json['content'] as String,
        format: json['format'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  static String encodeList(List<ScanRecord> records) =>
      jsonEncode(records.map((r) => r.toJson()).toList());

  static List<ScanRecord> decodeList(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((e) => ScanRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
