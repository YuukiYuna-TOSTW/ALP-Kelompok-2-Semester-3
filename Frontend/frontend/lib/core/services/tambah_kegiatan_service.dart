import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show Platform, File;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TambahKegiatanService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  static Future<List<Map<String, dynamic>>> getPenyelenggara() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/schedules/penyelenggara'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List data = (body['data'] ?? []) as List;
        return data.map<Map<String, dynamic>>((e) => {
          'id': (e['id'] is int) ? e['id'] : int.tryParse('${e['id']}') ?? 0,
          'nama': (e['nama'] ?? '-').toString(),
        }).where((e) => e['id'] != 0).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Kirim data dengan multipart jika ada lampiran
  static Future<Map<String, dynamic>> createSchedule({
    required String namaKegiatan,
    required String deskripsi,
    required DateTime tanggalMulai,
    required String waktuMulai,   // HH:mm
    required DateTime tanggalSelesai,
    required String waktuSelesai, // HH:mm
    required int penyelenggaraId,
    String? tempat,
    // ✅ untuk upload
    String? lampiranPath,         // non-Web
    Uint8List? lampiranBytes,     // Web
    String? lampiranName,
    String status = 'Terjadwal',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/schedules');
      final fields = {
        'Nama_Kegiatan': namaKegiatan.trim(),
        'Deskripsi': deskripsi.trim(),
        'Tanggal_Mulai': tanggalMulai.toIso8601String().split('T')[0],
        'Waktu_Mulai': waktuMulai,
        'Tanggal_Selesai': tanggalSelesai.toIso8601String().split('T')[0],
        'Waktu_Selesai': waktuSelesai,
        'Penyelenggara_ID': penyelenggaraId.toString(),
        'Tempat': (tempat ?? '').trim(),
        'Status': status,
      };

      final hasAttachment =
          (kIsWeb && lampiranBytes != null && lampiranBytes.isNotEmpty) ||
          (!kIsWeb && (lampiranPath != null && lampiranPath.isNotEmpty));

      if (hasAttachment) {
        final req = http.MultipartRequest('POST', uri)..fields.addAll(fields);

        if (kIsWeb) {
          req.files.add(http.MultipartFile.fromBytes(
            'Lampiran',                       // ✅ key harus sama dengan di Laravel
            lampiranBytes!,
            filename: lampiranName ?? 'lampiran',
          ));
        } else {
          req.files.add(await http.MultipartFile.fromPath(
            'Lampiran',                       // ✅ key harus sama dengan di Laravel
            lampiranPath!,
          ));
        }

        final streamed = await req.send().timeout(const Duration(seconds: 60));
        final res = await http.Response.fromStream(streamed);
        final body = jsonDecode(res.body);
        final ok = res.statusCode == 201;

        return {
          'success': ok,
          'message': body['message'] ?? (ok ? 'Kegiatan disimpan' : 'Gagal menyimpan'),
          'data': body['data'] ?? {},
          'statusCode': res.statusCode,
        };
      }

      // tanpa lampiran → JSON biasa
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          ...fields,
          'Penyelenggara_ID': penyelenggaraId, // angka untuk JSON
        }),
      ).timeout(const Duration(seconds: 30));

      final body = jsonDecode(res.body);
      final ok = res.statusCode == 201;
      return {
        'success': ok,
        'message': body['message'] ?? (ok ? 'Kegiatan disimpan' : 'Gagal menyimpan'),
        'data': body['data'] ?? {},
        'statusCode': res.statusCode,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': {}};
    }
  }
}