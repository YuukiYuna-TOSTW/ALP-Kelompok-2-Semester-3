import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class AdminRightPanel extends StatelessWidget {
  const AdminRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // ===============================
    // 📌 DAFTAR KEGIATAN SEKOLAH
    // ===============================
    final events = [
      CalendarEvent(date: DateTime(2025, 1, 10), title: "Rapat Guru"),
      CalendarEvent(date: DateTime(2025, 1, 10), title: "Supervisi Kelas 9"),
      CalendarEvent(
        date: DateTime(2025, 1, 14),
        title: "Perbaikan Template RPP",
      ),
      CalendarEvent(
        date: DateTime(2025, 1, 21),
        title: "Workshop Kurikulum Merdeka",
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 0, 4, 40),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // =======================================
          // ⭐ Aktivitas Sistem Terbaru
          // =======================================
          const Text(
            "Aktivitas Sistem Terbaru",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          const GuruActivityTile(
            icon: Icons.calendar_month,
            title: "Jadwal 9B diperbarui",
            time: "2 menit lalu",
          ),
          const GuruActivityTile(
            icon: Icons.person_add_alt_1_rounded,
            title: "Guru baru ditambahkan: Bu Sinta",
            time: "15 menit lalu",
          ),
          const GuruActivityTile(
            icon: Icons.menu_book_rounded,
            title: "Template RPP direvisi",
            time: "1 jam lalu",
          ),
          const GuruActivityTile(
            icon: Icons.book_rounded,
            title: "Admin menambah mata pelajaran baru",
            time: "3 jam lalu",
          ),

          const SizedBox(height: 28),

          // =======================================
          // ⭐ Kalender Sekolah (MiniCalendar Baru)
          // =======================================
          const Text(
            "Kalender Sekolah",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // ✔ MiniCalendar sudah otomatis handle event + highlight + daftar kegiatan
          MiniCalendar(events: events),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
