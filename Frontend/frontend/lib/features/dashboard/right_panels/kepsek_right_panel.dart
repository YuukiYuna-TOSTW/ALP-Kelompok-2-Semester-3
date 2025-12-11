import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class KepsekRightPanel extends StatefulWidget {
  const KepsekRightPanel({super.key});

  @override
  State<KepsekRightPanel> createState() => _KepsekRightPanelState();
}

class _KepsekRightPanelState extends State<KepsekRightPanel> {
  // ===============================
  // 📌 EVENT KALENDER
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

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
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
            title: "Bu guru Tika mengupload RPP PJOK",
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
            "Jadwal Sekolah",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Kalender -> ketika klik akan kirim tanggal terpilih
          MiniCalendar(
            events: events,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),

          const SizedBox(height: 20),

          // ===============================
          // ⭐ LIST EVENT DI BAWAH KALENDER
          // ===============================
          if (selectedDate != null) _buildEventList(selectedDate!),
        ],
      ),
    );
  }

  // ===========================================================
  // 🔵 WIDGET LIST EVENT SETELAH TANGGAL DI KALENDER DIKLIK
  // ===========================================================
  Widget _buildEventList(DateTime date) {
    final todaysEvents = events
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();

    if (todaysEvents.isEmpty) {
      return const Text(
        "Tidak ada kegiatan di tanggal ini.",
        style: TextStyle(color: AppColors.textGrey, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kegiatan pada ${date.day}/${date.month}/${date.year}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),

        ...todaysEvents.map(
          (event) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
