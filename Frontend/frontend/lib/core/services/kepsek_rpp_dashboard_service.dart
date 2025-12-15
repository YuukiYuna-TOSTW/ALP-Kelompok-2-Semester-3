import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class KepsekRppDashboardService {
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

  static Future<Map<String, dynamic>> getRppPendingReview() async {
    final url = Uri.parse('$baseUrl/dashboard/rpps/pending');
    try {
      final res = await http.get(url, headers: _headers).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        return {'success': false, 'data': [], 'message': 'HTTP ${res.statusCode}'};
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      // Unwrap jika server mengirim {"data": {"data": [...]}}
      final rawData = body['data'];
      final list = rawData is List ? rawData : (rawData is Map ? (rawData['data'] ?? []) : []);
      return {
        'success': body['success'] ?? true,
        'data': list is List ? list : [],
        'message': body['message'] ?? 'OK',
      };
    } on SocketException {
      return {'success': false, 'data': [], 'message': 'Gagal terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'data': [], 'message': 'Permintaan waktu habis'};
    } catch (e) {
      return {'success': false, 'data': [], 'message': 'Terjadi kesalahan: $e'};
    }
  }
}