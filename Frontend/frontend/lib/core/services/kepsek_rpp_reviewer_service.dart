import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KepsekRppReviewerService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api'; // emulator Android
  }

  // GET catatan reviewer
  static Future<Map<String, dynamic>> getNotes(int rppId) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/rpps/$rppId/rppreviewer'),
              headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return {
          'success': true,
          'message': body['message'] ?? 'OK',
          'data': body['data'] ?? {},
        };
      }
      return {
        'success': false,
        'message': 'Gagal memuat catatan: ${res.statusCode}',
        'data': {},
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Timeout. Pastikan backend di $baseUrl hidup.',
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

  // PUT / upsert catatan reviewer
  // notes map key: KD, KI, Tujuan, Pendahuluan, Inti, Penutup, Catatan Umum
  static Future<Map<String, dynamic>> upsertNotes(
      int rppId, Map<String, String> notes) async {
    final payload = {
      'Catatan_KD': notes['KD'] ?? '',
      'Catatan_KI': notes['KI'] ?? '',
      'Catatan_Tujuan': notes['Tujuan'] ?? '',
      'Catatan_Pendahuluan': notes['Pendahuluan'] ?? '',
      'Catatan_Inti': notes['Inti'] ?? '',
      'Catatan_Penutup': notes['Penutup'] ?? '',
      'Catatan_Umum': notes['Catatan Umum'] ?? '',
    };

    try {
      final res = await http
          .put(
            Uri.parse('$baseUrl/rpps/$rppId/rppreviewer'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200 || res.statusCode == 201,
        'message': body['message'] ?? 'Gagal menyimpan',
        'data': body['data'] ?? {},
        'statusCode': res.statusCode,
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Timeout. Pastikan backend di $baseUrl hidup.',
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

  // DELETE: kosongkan catatan reviewer
  static Future<Map<String, dynamic>> clearNotes(int rppId) async {
    try {
      final res = await http
          .delete(
            Uri.parse('$baseUrl/rpps/$rppId/rppreviewer'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      final body = jsonDecode(res.body);
      return {
        'success': res.statusCode == 200,
        'message': body['message'] ?? 'Gagal menghapus',
        'data': body['data'] ?? {},
        'statusCode': res.statusCode,
      };
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Timeout. Pastikan backend di $baseUrl hidup.',
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