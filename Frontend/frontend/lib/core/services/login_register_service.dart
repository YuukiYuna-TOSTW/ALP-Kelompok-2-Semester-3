import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class LoginRegisterService {
  // Untuk web gunakan localhost:8000, untuk Android emulator gunakan 10.0.2.2
  static String get baseUrl {
    // web (Chrome / Edge) -> gunakan localhost
    if (kIsWeb) return 'http://localhost:8000/api';

    // non-web: gunakan 127.0.0.1 untuk Windows / macOS (native desktop) atau device fisik
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return 'http://127.0.0.1:8000/api';
      }
    } catch (_) {
      // Platform tidak tersedia pada web - diabaikan
    }

    // Android emulator default
    return 'http://10.0.2.2:8000/api';
  }

  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> register({
    required String namaUser,
    required String email,
    required String password,
    String role = 'Guru',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'), // ✅ ubah dari /users ke /register
            headers: _headers,
            body: jsonEncode({
              'Nama_User': namaUser,
              'Email': email,
              'Password': password,
              'Role': role,
            }),
          )
          .timeout(const Duration(seconds: 12));

      final body = _decode(response.body);
      final msg = _pickMessage(body, response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': msg};
      }
      return {'success': false, 'message': msg};
    } on SocketException {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Permintaan waktu habis'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: _headers,
            body: jsonEncode({'Email': email, 'Password': password}),
          )
          .timeout(const Duration(seconds: 12));

      final body = _decode(response.body);
      final msg = _pickMessage(body, response.statusCode);

      if (response.statusCode == 200) {
        return {'success': true, 'message': msg, 'data': body};
      }
      return {'success': false, 'message': msg};
    } on SocketException {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Permintaan waktu habis'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan'};
    }
  }

  static Map<String, dynamic> _decode(String src) {
    try {
      return jsonDecode(src) as Map<String, dynamic>;
    } catch (_) {
      // kembalikan message di field 'message' agar _pickMessage selalu menerima Map
      return {'message': src};
    }
  }

  static String _pickMessage(Map<String, dynamic> body, int status) {
    final rawMsg = (body['message'] ?? '').toString();

    if (rawMsg.trim().isEmpty && body['errors'] is Map) {
      final errors = body['errors'] as Map;
      if (errors.isNotEmpty) {
        final first = errors.values.first;
        final candidate = (first is List && first.isNotEmpty) ? first.first.toString() : first.toString();
        return _sanitize(candidate, status);
      }
    }

    if (rawMsg.trim().isNotEmpty) {
      return _sanitize(rawMsg, status);
    }

    if (status == 404) return 'Endpoint tidak ditemukan';
    if (status >= 500) return 'Terjadi kesalahan pada server, coba lagi nanti';
    return 'Gagal (${status})';
  }

  static String _sanitize(String msg, int status) {
    final low = msg.toLowerCase();
    final isHtml = low.contains('<!doctype') || low.contains('<html') || low.contains('<head') || low.contains('<body') || msg.trim().startsWith('<');
    if (isHtml) {
      if (status == 404) return 'Endpoint tidak ditemukan';
      if (status >= 500) return 'Terjadi kesalahan pada server, coba lagi nanti';
      return 'Respon server tidak valid';
    }

    if (msg.length > 300) {
      if (status >= 500) return 'Terjadi kesalahan pada server, coba lagi nanti';
      return msg.substring(0, 300) + '...';
    }

    return msg;
  }
}