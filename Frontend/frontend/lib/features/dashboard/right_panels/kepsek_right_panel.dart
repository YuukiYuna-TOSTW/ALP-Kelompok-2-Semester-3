import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../core/services/kepsek_kalender_dashboard_service.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';

class KepsekRightPanel extends StatefulWidget {
  const KepsekRightPanel({super.key});

  @override
  State<KepsekRightPanel> createState() => _KepsekRightPanelState();
}

class _KepsekRightPanelState extends State<KepsekRightPanel> {
  late Future<List<CalendarEvent>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = KepsekKalenderDashboardService.getSchedules();
  }

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

          // ✅ FutureBuilder untuk load schedule dari Laravel
          FutureBuilder<List<CalendarEvent>>(
            future: _schedulesFuture,
            builder: (context, snapshot) {
              final events = snapshot.data ?? [];
              return MiniCalendar(events: events);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
