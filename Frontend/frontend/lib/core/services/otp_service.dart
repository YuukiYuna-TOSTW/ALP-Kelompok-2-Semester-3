import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>> generateOtp({
    required String email,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/otp/generate'),
            headers: _headers,
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          // ✅ JANGAN return otp_code ke frontend (hanya untuk testing)
          'message': body['message'] ?? 'OTP berhasil dikirim ke email',
        };
      }
      return {
        'success': false,
        'message': 'Gagal generate OTP: ${res.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/otp/generate'),
            headers: _headers,
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          // ✅ JANGAN return otp_code ke frontend
          'message': body['message'] ?? 'OTP baru berhasil dikirim',
        };
      }
      return {
        'success': false,
        'message': 'Gagal kirim ulang OTP: ${res.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/otp/verify'),
            headers: _headers,
            body: jsonEncode({'email': email, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final userData = body['user'] ?? {};

        // ✅ Simpan user data dari backend
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Nama_User', userData['Nama_User'] ?? '');
        await prefs.setString('Email', userData['Email'] ?? '');
        await prefs.setString('Role', userData['Role'] ?? 'guru');

        return {
          'success': true,
          'message': body['message'] ?? 'OTP berhasil diverifikasi',
          'user': userData,
        };
      }

      final body = jsonDecode(res.body);
      return {
        'success': false,
        'message': body['message'] ?? 'OTP tidak valid atau kadaluarsa',
        'user': {},
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'user': {},
      };
    }
  }
}
