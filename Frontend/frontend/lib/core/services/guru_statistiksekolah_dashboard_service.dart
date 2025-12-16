import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class GuruStatistikSekolahDashboardService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return 'http://127.0.0.1:8000/api';
      }
    } catch (_) {}
    return 'http://10.0.2.2:8000/api';
  }

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Ambil data mentah dan hitung statistik di client
  static Future<Map<String, dynamic>> getStatistics({
    String namaUser = 'Kelompok2Guru',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/dashboard/gurustatistiksekolah')
          .replace(queryParameters: {'nama_user': namaUser});
      
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        // ✅ HITUNG DI CLIENT
        final schedules = (data['schedules'] ?? []) as List;
        final rppList = (data['rpp_pending'] ?? []) as List;
        
        final currentDate = DateTime.parse(data['current_date']);
        final currentTime = data['current_time'] as String;
        
        double totalJam = 0.0;
        double sisaJam = 0.0;

        for (var schedule in schedules) {
          final tanggalMulai = DateTime.parse(schedule['Tanggal_Mulai']);
          final tanggalSelesai = DateTime.parse(schedule['Tanggal_Selesai']);
          
          final waktuMulai = _parseTime(schedule['Waktu_Mulai']);
          final waktuSelesai = _parseTime(schedule['Waktu_Selesai']);
          
          // Durasi dalam jam
          final durasi = waktuSelesai.difference(waktuMulai).inMinutes / 60.0;
          totalJam += durasi;

          // Hitung sisa waktu
          double sisa = durasi;
          
          if (tanggalSelesai.isBefore(currentDate)) {
            sisa = 0;
          } else if (tanggalMulai.isAfter(currentDate)) {
            sisa = durasi;
          } else {
            // Hari ini
            final currentDateTime = DateTime.parse('${currentDate.toIso8601String().split('T')[0]} $currentTime');
            final scheduleStart = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              waktuMulai.hour,
              waktuMulai.minute,
            );
            final scheduleEnd = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              waktuSelesai.hour,
              waktuSelesai.minute,
            );

            if (currentDateTime.isAfter(scheduleStart) && currentDateTime.isBefore(scheduleEnd)) {
              // Sedang berlangsung
              final berlalu = currentDateTime.difference(scheduleStart).inMinutes / 60.0;
              sisa = (durasi - berlalu).clamp(0.0, durasi);
            } else if (currentDateTime.isAfter(scheduleEnd)) {
              sisa = 0;
            }
          }
          
          sisaJam += sisa;
        }

        return {
          'success': true,
          'data': {
            'nama_guru': data['nama_guru'],
            'rpp_pending': rppList.length,
            'total_kelas': schedules.length,
            'total_jam': double.parse(totalJam.toStringAsFixed(2)),
            'sisa_jam': double.parse(sisaJam.toStringAsFixed(2)),
            'tanggal_mulai_minggu': data['tanggal_mulai_minggu'],
            'tanggal_selesai_minggu': data['tanggal_selesai_minggu'],
          },
          'message': 'Data berhasil dimuat',
        };
      }

      return {
        'success': false,
        'data': {},
        'message': 'Gagal memuat data (${response.statusCode})',
      };
    } on SocketException {
      return {
        'success': false,
        'data': {},
        'message': 'Gagal terhubung ke server',
      };
    } on TimeoutException {
      return {
        'success': false,
        'data': {},
        'message': 'Permintaan waktu habis',
      };
    } catch (e) {
      return {
        'success': false,
        'data': {},
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// Helper: Parse string time "HH:mm:ss" ke DateTime
  static DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }
}