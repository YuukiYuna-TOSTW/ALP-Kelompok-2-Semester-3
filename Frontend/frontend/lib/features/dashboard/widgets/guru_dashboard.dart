import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';
import '../components/schedule_card.dart'; // ✔ Perbaikan

class GuruDashboardContent extends StatelessWidget {
  const GuruDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // ===============================
        // ⭐ JADWAL MENGAJAR HARI INI
        // ===============================
        const Text(
          "Jadwal Mengajar Hari Ini",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: const [
              ScheduleCard(
                time: "08:00 – 09:30",
                subject: "Matematika",
                className: "8A",
                room: "Ruang 12",
              ),
              SizedBox(height: 10),
              ScheduleCard(
                time: "10:00 – 11:30",
                subject: "IPA",
                className: "7B",
                room: "Ruang 8",
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ===============================
        // ⭐ STATISTIK MINGGUAN
        // ===============================
        const Text(
          "Statistik Mingguan",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: const [
            Expanded(
              child: StatCard(
                icon: Icons.menu_book_rounded,
                value: "6",
                title: "RPP Pending",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.class_rounded,
                value: "3",
                title: "Total Kelas",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.schedule_rounded,
                value: "12",
                title: "Jam Mengajar",
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ===============================
        // ⭐ AKSI CEPAT
        // ===============================
        const Text(
          "Aksi Cepat",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: const [
            Expanded(
              child: QuickActionButton(
                icon: Icons.upload_file_rounded,
                label: "Upload RPP",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: QuickActionButton(
                icon: Icons.description_rounded,
                label: "Template RPP",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: QuickActionButton(
                icon: Icons.file_download_done_rounded,
                label: "Export Jadwal",
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
