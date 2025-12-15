import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:frontend/features/dashboard/components/mini_calendar.dart'; // ✅ import CalendarEvent dari sini

class KepsekKalenderDashboardService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return 'http://127.0.0.1:8000/api';
      }
    } catch (_) {}
    return 'http://10.0.2.2:8000/api';
  }

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<List<CalendarEvent>> getSchedules() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/dashboard/kepsekkalender'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        print('❌ Status: ${res.statusCode}');
        return [];
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as List? ?? [];

      return data.map((item) {
        return CalendarEvent(
          date: DateTime.tryParse(item['Tanggal_Mulai'] ?? '') ?? DateTime.now(),
          title: item['Nama_Kegiatan'] ?? 'Kegiatan',
        );
      }).toList();
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }
}