import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AdminRppService {
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

  static Future<Map<String, dynamic>> getAllRpp() async {
    final url = Uri.parse('$baseUrl/dashboard/admin/rpps');
    try {
      final res = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        return {
          'success': false,
          'data': [],
          'message': 'Gagal memuat RPP (${res.statusCode})',
        };
      }

      final body = jsonDecode(res.body);
      return {
        'success': true,
        'data': body['data'] ?? [],
        'message': 'Data RPP dimuat',
      };
    } on SocketException {
      return {
        'success': false,
        'data': [],
        'message': 'Gagal terhubung ke server',
      };
    } on TimeoutException {
      return {
        'success': false,
        'data': [],
        'message': 'Permintaan waktu habis',
      };
    } catch (e) {
      return {'success': false, 'data': [], 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
