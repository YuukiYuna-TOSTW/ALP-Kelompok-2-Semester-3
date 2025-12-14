import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class KepsekRightPanel extends StatelessWidget {
  const KepsekRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // ===============================
    // 📌 DAFTAR KEGIATAN SEKOLAH
    // ===============================
    final List<CalendarEvent> events = [
      CalendarEvent(date: DateTime(2025, 1, 10), title: "Rapat Guru"),
      CalendarEvent(date: DateTime(2025, 1, 10), title: "Supervisi Kelas"),
      CalendarEvent(
        date: DateTime(2025, 1, 14),
        title: "Pemeriksaan RPP Tahunan",
      ),
      CalendarEvent(date: DateTime(2025, 1, 14), title: "Kegiatan OSIS"),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 0, 4, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ===============================
          // ⭐ Aktivitas Terbaru
          // ===============================
          const Text(
            "Aktivitas Terbaru",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          const GuruActivityTile(
            icon: Icons.check_circle_rounded,
            title: "RPP kelas 9A telah disetujui",
            time: "5 menit lalu",
          ),
          const GuruActivityTile(
            icon: Icons.upload_file,
            title: "Bu Tika mengupload RPP PJOK",
            time: "30 menit lalu",
          ),
          const GuruActivityTile(
            icon: Icons.calendar_month,
            title: "Jadwal kelas 7C diperbarui oleh admin",
            time: "1 jam lalu",
          ),

          const SizedBox(height: 28),

          // ===============================
          // ⭐ Kalender Sekolah
          // ===============================
          const Text(
            "Kalender Sekolah",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          MiniCalendar(events: events),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
