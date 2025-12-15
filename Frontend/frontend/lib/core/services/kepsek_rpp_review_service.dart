import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KepsekRppReviewService {
  // Basis URL menyesuaikan platform
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api'; // chrome/edge (web)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api'; // desktop
    }
    // fallback (jika nanti dipakai emulator Android/iOS)
    return 'http://10.0.2.2:8000/api';
  }

  /// Ambil info RPP (tanpa catatan reviewer) dari endpoint baru: /api/rpp-info/{rppId}
  static Future<Map<String, dynamic>> getRppInfo(int rppId) async {
    try {
      final uri = Uri.parse('$baseUrl/rppreview/$rppId');
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
        return {
          'success': false,
          'message': 'RPP tidak ditemukan',
          'data': {},
        };
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
      return {
        'success': false,
        'message': 'Error: $e',
        'data': {},
      };
    }
  }
}