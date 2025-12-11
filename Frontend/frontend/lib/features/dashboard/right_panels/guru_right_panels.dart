import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class GuruRightPanel extends StatefulWidget {
  const GuruRightPanel({super.key});

  @override
  State<GuruRightPanel> createState() => _GuruRightPanelState();
}

class _GuruRightPanelState extends State<GuruRightPanel> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final events = [
      CalendarEvent(date: DateTime(2025, 1, 12), title: "Upacara Bendera"),
      CalendarEvent(date: DateTime(2025, 1, 12), title: "Piket Kelas 8A"),
      CalendarEvent(
        date: DateTime(2025, 1, 17),
        title: "Penilaian Tengah Semester",
      ),
    ];

    // Filter event sesuai tanggal terpilih
    final selectedEvents = selectedDate == null
        ? []
        : events
              .where(
                (e) =>
                    e.date.year == selectedDate!.year &&
                    e.date.month == selectedDate!.month &&
                    e.date.day == selectedDate!.day,
              )
              .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 0, 4, 40),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ===============================
          // ⭐ Aktivitas
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
          // ⭐ Daftar Kegiatan (muncul setelah klik tanggal)
          // ===============================
          if (selectedEvents.isNotEmpty) ...[
            Text(
              "Kegiatan pada ${selectedDate!.day} "
              "${months[selectedDate!.month - 1]} ${selectedDate!.year}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),

            ...selectedEvents.map(
              (e) => Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.title,
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
        ],
      ),
    );
  }
}

final months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "Mei",
  "Jun",
  "Jul",
  "Agu",
  "Sep",
  "Okt",
  "Nov",
  "Des",
];
