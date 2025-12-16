import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RppHistoryService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  /// Ambil semua RPP untuk Kepsek
  /// Response di-normalisasi ke struktur:
  /// { guru, mapel, kelas, semester, tanggal, status }
  static Future<Map<String, dynamic>> fetchAll() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/rpps'), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List items = (body['data'] ?? []) as List;
        final normalized = items.map<Map<String, dynamic>>((e) {
          return {
            'guru': '${e['Guru_Nama'] ?? '-'}',
            'mapel': '${e['Nama_Mata_Pelajaran'] ?? '-'}',
            'kelas': '${e['Kelas'] ?? '-'}',
            'semester': '${e['Semester'] ?? '-'}',
            'tanggal': '${e['created_at'] ?? '-'}',
            'status': '${e['Status'] ?? '-'}',
            'rpp_id': e['RPP_ID'],
          };
        }).toList();

        return {'success': true, 'data': normalized};
      }

      return {'success': false, 'message': 'Gagal memuat (${res.statusCode})', 'data': []};
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout. Pastikan backend berjalan.', 'data': []};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': []};
    }
  }
}