import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GuruRppEditService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  // GET /api/rpps/{id}
  static Future<Map<String, dynamic>> getDetail(int rppId) async {
    try {
      final uri = Uri.parse('$baseUrl/rpps/$rppId');
      final res = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          'message': body['message'] ?? 'OK',
          'data': body['data'] ?? {},
        };
      }
      if (res.statusCode == 404) {
        return {'success': false, 'message': 'RPP tidak ditemukan', 'data': {}};
      }
      return {
        'success': false,
        'message': 'Gagal memuat RPP: ${res.statusCode}',
        'data': {},
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timeout. Pastikan server Laravel berjalan di $baseUrl',
        'data': {},
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }

  // PUT /api/rpps/{id}
  static Future<Map<String, dynamic>> updateRpp(int rppId, Map<String, dynamic> payload) async {
    try {
      final uri = Uri.parse('$baseUrl/rpps/$rppId'); // ✅ gunakan RPP_ID langsung
      final res = await http
          .put(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          'message': body['message'] ?? 'Berhasil diperbarui',
          'data': body['data'] ?? {},
        };
      }
      if (res.statusCode == 422) {
        final body = jsonDecode(res.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Validasi gagal',
          'errors': body['errors'] ?? {},
        };
      }
      return {
        'success': false,
        'message': 'Gagal update RPP: ${res.statusCode}',
        'data': {},
      };
    } on TimeoutException {
      return {'success': false, 'message': 'Request timeout', 'data': {}};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }
}