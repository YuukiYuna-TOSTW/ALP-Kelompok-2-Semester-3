import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// Service untuk mengambil daftar RPP guru
/// - Filter berdasarkan Nama_User (default: Kelompok2Guru jika belum login)
/// - Hanya Role = Guru
class GuruRppListService {
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
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// Ambil RPP untuk user tertentu (Role Guru),
  /// jika namaUser null/empty, gunakan default "Kelompok2Guru".
  static Future<Map<String, dynamic>> fetchMyRpps({
    String? namaUser,
    String? status, // opsional filter status
  }) async {
    try {
      final user = (namaUser == null || namaUser.trim().isEmpty)
          ? 'Kelompok2Guru'
          : namaUser.trim();

      // Endpoint index RPP + filter via query (controller Anda: RppApiController@index)
      final uri = Uri.parse('$baseUrl/rpps').replace(queryParameters: {
        // backend: gunakan query tambahan bila Anda menambahkan filter Nama_User & Role di controller
        'nama_user': user,
        'role': 'Guru',
        if (status != null && status.isNotEmpty) 'status': status,
      });

      final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        return {'success': false, 'message': 'Gagal memuat (${res.statusCode})', 'data': []};
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final raw = body['data'];

      // Normalisasi ke struktur yang dipakai halaman guru_rpp_list_pages.dart
      // map: mapel, kelas, bab, semester, tanggalStr, tanggal(DateTime), status
      final List<Map<String, dynamic>> list = [];
      if (raw is List) {
        for (final item in raw) {
          // Resource Rpp Anda kemungkinan mengembalikan field seperti:
          // Nama_Mata_Pelajaran, Kelas, Semester, Bab/Materi, created_at/updated_at, Status, user->Nama_User
          final mapel = item['Nama_Mata_Pelajaran'] ?? item['mapel'] ?? '-';
          final kelas = item['Kelas'] ?? item['kelas'] ?? '-';
          final bab = item['Bab/Materi'] ?? item['bab'] ?? '-';
          final semester = item['Semester'] ?? item['semester'] ?? '-';
          final statusVal = (item['Status'] ?? item['status'] ?? '-').toString();
          final tanggalStrRaw = item['created_at'] ?? item['tanggal'] ?? null;

          // Parse tanggal ke DateTime + string tampilan (contoh konsisten: dd MMM yyyy)
          DateTime? tanggalDt;
          String tanggalStr = '-';
          if (tanggalStrRaw is String && tanggalStrRaw.isNotEmpty) {
            try {
              tanggalDt = DateTime.parse(tanggalStrRaw);
              // Format sederhana tanpa intl (untuk menjaga dependency)
              const months = [
                'Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'
              ];
              final m = months[tanggalDt.month - 1];
              tanggalStr = '${tanggalDt.day.toString().padLeft(2, '0')} $m ${tanggalDt.year}';
            } catch (_) {
              tanggalStr = tanggalStrRaw;
            }
          }

          list.add({
            'mapel': mapel.toString(),
            'kelas': kelas.toString(),
            'bab': bab.toString(),
            'semester': semester.toString(),
            'tanggalStr': tanggalStr,
            'tanggal': tanggalDt ?? DateTime.now(),
            'status': statusVal,
          });
        }
      }

      return {'success': true, 'data': list, 'message': 'OK'};
    } on TimeoutException {
      return {'success': false, 'data': [], 'message': 'Timeout'};
    } on SocketException {
      return {'success': false, 'data': [], 'message': 'Koneksi gagal'};
    } catch (e) {
      return {'success': false, 'data': [], 'message': 'Error: $e'};
    }
  }
}