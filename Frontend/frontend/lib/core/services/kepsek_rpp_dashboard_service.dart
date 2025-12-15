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

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> getRppPendingReview() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/rpps?status=Menunggu%20Review'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'data': body['data'] ?? [],
          'message': 'Data berhasil dimuat',
        };
      }
      return {
        'success': false,
        'data': [],
        'message': 'Gagal memuat data (${response.statusCode})',
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
      return {
        'success': false,
        'data': [],
        'message': 'Terjadi kesalahan',
      };
    }
  }
}