import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KepsekRppSetujuService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  static Future<Map<String, dynamic>> approve(int rppId) async {
    try {
      final res = await http
          .put(
            Uri.parse('$baseUrl/rpps/$rppId/rppsetujui'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(res.body);
      final ok = res.statusCode == 200;
      return {
        'success': ok,
        'message': body['message'] ?? (ok ? 'Status disetujui' : 'Gagal menyetujui'),
        'data': body['data'] ?? {},
        'statusCode': res.statusCode,
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timeout. Pastikan backend berjalan.',
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