import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RppReviewDetailService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api'; // Android emulator
  }

  /// GET detail lengkap RPP untuk review
  static Future<Map<String, dynamic>> getDetail(int rppId) async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/rpps/$rppId/rppdetail'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          'message': body['message'] ?? 'Detail dimuat',
          'data': body['data'] ?? {},
        };
      }

      return {
        'success': false,
        'message': 'Gagal memuat detail (${res.statusCode})',
        'data': null,
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Timeout. Pastikan backend berjalan.',
        'data': null,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null,
      };
    }
  }
}