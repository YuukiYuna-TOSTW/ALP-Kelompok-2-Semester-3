import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:frontend/features/dashboard/components/mini_calendar.dart'; // CalendarEvent
import 'package:shared_preferences/shared_preferences.dart'; // tambah

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

  /// Ambil jadwal kalender untuk guru tertentu (namaUser opsional)
  static Future<List<CalendarEvent>> getSchedules({
    String? namaUser,
  }) async {
    try {
      // Ambil dari parameter, jika null/empty ambil dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final resolvedUser = (namaUser != null && namaUser.trim().isNotEmpty)
          ? namaUser.trim()
          : (prefs.getString('Nama_User') ?? '');

      if (resolvedUser.isEmpty) {
        print('❌ Nama_User kosong, silakan login ulang');
        return [];
      }

      final uri = Uri.parse('$baseUrl/dashboard/gurukalender')
          .replace(queryParameters: {'nama_user': resolvedUser});

      final res = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 12));

      if (res.statusCode != 200) {
        print('❌ Status: ${res.statusCode}');
        return [];
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as List? ?? [];

      print('📅 Guru Kalender: loaded ${data.length} schedules (user: $resolvedUser)');
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
        return CalendarEvent(
          date: DateTime(date.year, date.month, date.day),
          title: item['Nama_Kegiatan'] ?? 'Kegiatan',
        );
      }).toList();
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }
}
