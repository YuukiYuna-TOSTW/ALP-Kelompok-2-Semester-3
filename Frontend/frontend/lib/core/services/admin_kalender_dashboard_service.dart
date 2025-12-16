import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:frontend/features/dashboard/components/mini_calendar.dart';

class AdminKalenderDashboardService {
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
            Uri.parse('$baseUrl/dashboard/admin/kalender'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 12));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final data = body['data'] as List<dynamic>? ?? [];

        print('📅 Admin Kalender: loaded ${data.length} schedules');
        if (data.isNotEmpty) {
          print('📅 First schedule: ${data.first}');
        }

        final events = data.map((item) {
          // Parse ISO 8601 format atau YYYY-MM-DD
          final tanggalStr = item['Tanggal_Mulai'] as String;
          DateTime date;

          try {
            // Coba parse sebagai ISO 8601 atau DateTime string
            date = DateTime.parse(tanggalStr);
          } catch (e) {
            print('⚠️ Failed to parse date: $tanggalStr - $e');
            date = DateTime.now();
          }

          final event = CalendarEvent(
            date: DateTime(date.year, date.month, date.day),
            title: item['Nama_Kegiatan'] as String,
          );

          print('📅 Mapped: ${item['Nama_Kegiatan']} -> ${event.date}');

          return event;
        }).toList();

        print('📅 Total events created: ${events.length}');
        return events;
      }
      print('❌ Admin Kalender: HTTP ${res.statusCode}');
      return [];
    } on SocketException catch (e) {
      print('❌ Admin Kalender: SocketException - $e');
      return [];
    } on TimeoutException catch (e) {
      print('❌ Admin Kalender: TimeoutException - $e');
      return [];
    } catch (e) {
      print('❌ Admin Kalender: Error - $e');
      return [];
    }
  }
}
