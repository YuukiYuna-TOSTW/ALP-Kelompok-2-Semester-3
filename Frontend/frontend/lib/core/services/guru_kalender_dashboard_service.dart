import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:frontend/features/dashboard/components/mini_calendar.dart'; // CalendarEvent

class GuruKalenderDashboardService {
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

  /// Ambil jadwal kalender untuk guru tertentu (namaUser opsional, default Kelompok2Guru)
  static Future<List<CalendarEvent>> getSchedules({
    String namaUser = 'Kelompok2Guru',
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/dashboard/gurukalender',
      ).replace(queryParameters: {'nama_user': namaUser});
      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        print('❌ Status: ${res.statusCode}');
        return [];
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as List? ?? [];

      print('📅 Guru Kalender: loaded ${data.length} schedules');
      if (data.isNotEmpty) {
        print('📅 First schedule: ${data.first}');
      }

      return data.map<CalendarEvent>((item) {
        final tanggalStr = item['Tanggal_Mulai'] ?? '';
        DateTime date;

        try {
          date = DateTime.parse(tanggalStr);
        } catch (e) {
          print('⚠️ Failed to parse date: $tanggalStr - $e');
          date = DateTime.now();
        }

        final event = CalendarEvent(
          date: DateTime(date.year, date.month, date.day),
          title: item['Nama_Kegiatan'] ?? 'Kegiatan',
        );

        print('📅 Guru Mapped: ${item['Nama_Kegiatan']} -> ${event.date}');

        return event;
      }).toList();
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }
}
