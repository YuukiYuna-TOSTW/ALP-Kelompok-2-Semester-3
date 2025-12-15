import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class OtpService {
  // Gunakan base URL yang sama dengan LoginRegisterService
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';

    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return 'http://127.0.0.1:8000/api';
      }
    } catch (_) {}

    return 'http://10.0.2.2:8000/api';
  }

  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Generate OTP untuk email tertentu
  static Future<Map<String, dynamic>> generateOtp({
    required String email,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/otp/generate'),
            headers: _headers,
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 12));

      final body = _decode(response.body);
      final msg = _pickMessage(body, response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract OTP code dari response (backend uses lowercase)
        final otpCode =
            body['data']?['kode_otp'] ?? body['data']?['Kode_OTP'] ?? '';
        final expiredAt =
            body['data']?['expired_at'] ?? body['data']?['Expired_At'] ?? '';

        return {
          'success': true,
          'message': msg,
          'otp_code': otpCode,
          'expired_at': expiredAt,
        };
      }
      return {'success': false, 'message': msg};
    } on SocketException {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Permintaan waktu habis'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  /// Verify OTP code
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String kodeOtp,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/otp/verify'),
            headers: _headers,
            body: jsonEncode({'email': email, 'kode_otp': kodeOtp}),
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
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  /// Resend OTP (sama seperti generate)
  static Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/otp/resend'),
            headers: _headers,
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 12));

      final body = _decode(response.body);
      final msg = _pickMessage(body, response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final otpCode =
            body['data']?['kode_otp'] ?? body['data']?['Kode_OTP'] ?? '';
        final expiredAt =
            body['data']?['expired_at'] ?? body['data']?['Expired_At'] ?? '';

        return {
          'success': true,
          'message': msg,
          'otp_code': otpCode,
          'expired_at': expiredAt,
        };
      }
      return {'success': false, 'message': msg};
    } on SocketException {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Permintaan waktu habis'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  /// Get OTP by email
  static Future<Map<String, dynamic>> getOtpByEmail({
    required String email,
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/otp/$email'), headers: _headers)
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
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Map<String, dynamic> _decode(String src) {
    try {
      return jsonDecode(src) as Map<String, dynamic>;
    } catch (_) {
      return {'message': src};
    }
  }

  static String _pickMessage(Map<String, dynamic> body, int status) {
    final rawMsg = (body['message'] ?? '').toString();

    if (rawMsg.trim().isEmpty && body['errors'] is Map) {
      final errors = body['errors'] as Map;
      if (errors.isNotEmpty) {
        final first = errors.values.first;
        final candidate = (first is List && first.isNotEmpty)
            ? first.first.toString()
            : first.toString();
        return _sanitize(candidate, status);
      }
    }

    if (rawMsg.trim().isNotEmpty) {
      return _sanitize(rawMsg, status);
    }

    if (status == 404) return 'Endpoint tidak ditemukan';
    if (status >= 500) {
      return 'Terjadi kesalahan pada server, coba lagi nanti';
    }
    return 'Gagal (${status})';
  }

  static String _sanitize(String msg, int status) {
    final low = msg.toLowerCase();
    final isHtml =
        low.contains('<!doctype') ||
        low.contains('<html') ||
        low.contains('<head') ||
        low.contains('<body') ||
        msg.trim().startsWith('<');
    if (isHtml) {
      if (status == 404) return 'Endpoint tidak ditemukan';
      if (status >= 500) {
        return 'Terjadi kesalahan pada server, coba lagi nanti';
      }
      return 'Respon server tidak valid';
    }

    if (msg.length > 300) {
      if (status >= 500) {
        return 'Terjadi kesalahan pada server, coba lagi nanti';
      }
      return msg.substring(0, 300) + '...';
    }

    return msg;
  }
}
