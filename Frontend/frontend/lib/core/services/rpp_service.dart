import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class RppService {
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

  static Future<Map<String, dynamic>> createRpp({
    required Map<String, dynamic> payload,
    String namaUser = 'Kelompok2Guru', // ✅ default user
  }) async {
    try {
      final body = {
        'Nama_User': namaUser, // ✅ kirim nama user, backend isi User_ID
        ...payload,
      };
      final res = await http
          .post(Uri.parse('$baseUrl/rpps'), headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 201 || res.statusCode == 200) {
        return {'success': true, 'message': 'RPP berhasil disimpan'};
      }
      final decoded = jsonDecode(res.body);
      return {
        'success': false,
        'message': decoded['message'] ?? 'Gagal menyimpan RPP (${res.statusCode})',
      };
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout saat menyimpan RPP'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}