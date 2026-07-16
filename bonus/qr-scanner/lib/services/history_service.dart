import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_record.dart';

class HistoryService {
  HistoryService._();
  static final HistoryService instance = HistoryService._();

  static const _key = 'scan_history';

  Future<List<ScanRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final records = ScanRecord.decodeList(raw);
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  Future<void> addScan(ScanRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, record);
    await prefs.setString(_key, ScanRecord.encodeList(history));
  }

  Future<void> deleteScan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.removeWhere((r) => r.id == id);
    await prefs.setString(_key, ScanRecord.encodeList(history));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
