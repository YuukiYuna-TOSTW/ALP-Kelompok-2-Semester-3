import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/guru_activity_tile.dart';
import '../components/mini_calendar.dart';
import '../../../core/services/guru_kalender_dashboard_service.dart'; // ✅ tambah

class GuruRightPanel extends StatefulWidget {
  const GuruRightPanel({super.key});

  @override
  State<GuruRightPanel> createState() => _GuruRightPanelState();
}

class _GuruRightPanelState extends State<GuruRightPanel> {
  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await GuruKalenderDashboardService.getSchedules(
      namaUser: 'Kelompok2Guru', // patokan user
    );
    if (mounted) setState(() => _events = data);
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

          // Layout tetap, hanya sumber data diganti service
          MiniCalendar(events: _events),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
