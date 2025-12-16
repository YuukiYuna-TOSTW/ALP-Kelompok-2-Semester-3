import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ScheduleReviewService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  /// GET semua schedule
  static Future<List<Map<String, dynamic>>> getAllSchedules() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/schedule-review'), // ✅ pakai dash, sesuai controller
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List data = (body['data'] ?? []) as List;
        
        return data.map<Map<String, dynamic>>((e) => {
          'Schedule_ID': e['Schedule_ID'],
          'Nama_Kegiatan': e['Nama_Kegiatan'] ?? '-',
          'Tanggal_Mulai': e['Tanggal_Mulai'] ?? '-',
          'Tanggal_Selesai': e['Tanggal_Selesai'] ?? '-',
          'Waktu_Mulai': e['Waktu_Mulai'] ?? '00:00',
          'Waktu_Selesai': e['Waktu_Selesai'] ?? '00:00',
          'Tempat': e['Tempat'] ?? '-',
          'Penyelenggara': e['Penyelenggara'] ?? 'Unknown',
          'Status': e['Status'] ?? 'Terjadwal',
          'Lampiran': e['Lampiran'],
        }).toList();
      }
      
      print('❌ Error Status: ${res.statusCode}');
      return [];
    } on TimeoutException {
      print('⏱️ Timeout saat fetch schedules');
      return [];
    } catch (e) {
      print('🔥 Exception getAllSchedules: $e');
      return [];
    }
  }

  /// GET detail satu schedule
  static Future<Map<String, dynamic>?> getScheduleDetail(int id) async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/schedule-review/$id'), // ✅ pakai dash
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return body['data'] as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      print('🔥 Exception getScheduleDetail: $e');
      return null;
    }
  }
}