import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class GuruRightPanel extends StatelessWidget {
  const GuruRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // ===============================
    // 📌 DAFTAR KEGIATAN SEKOLAH
    // ===============================
    final events = [
      CalendarEvent(date: DateTime(2025, 1, 12), title: "Upacara Bendera"),
      CalendarEvent(date: DateTime(2025, 1, 12), title: "Piket Kelas 8A"),
      CalendarEvent(
        date: DateTime(2025, 1, 17),
        title: "Penilaian Tengah Semester",
      ),
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
          const SizedBox(height: 10),

          const GuruActivityTile(
            icon: Icons.upload_file,
            title: "Kamu mengupload RPP kelas 8A",
            time: "10 menit lalu",
          ),
          const GuruActivityTile(
            icon: Icons.edit,
            title: "RPP kelas 9B diminta revisi",
            time: "1 jam lalu",
          ),
          const GuruActivityTile(
            icon: Icons.calendar_month,
            title: "Jadwal minggu depan diperbarui",
            time: "1 hari lalu",
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

          /// ✔ MiniCalendar otomatis menampilkan kegiatan hari terpilih
          /// ✔ Tidak perlu onDateSelected lagi
          MiniCalendar(events: events),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
