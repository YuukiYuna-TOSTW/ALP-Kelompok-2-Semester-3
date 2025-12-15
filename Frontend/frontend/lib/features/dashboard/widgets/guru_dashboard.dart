import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';
import '../components/schedule_card.dart';

class GuruDashboardContent extends StatelessWidget {
  const GuruDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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

          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  TeachingScheduleCard(
                    subject: "Matematika",
                    time: "08:00 – 09:30",
                    className: "8A",
                  ),
                  SizedBox(width: 14),
                  TeachingScheduleCard(
                    subject: "IPA",
                    time: "10:00 – 11:30",
                    className: "7B",
                  ),
                  SizedBox(width: 14),
                  TeachingScheduleCard(
                    subject: "Pendidikan Agama",
                    time: "12:30 – 14:00",
                    className: "9C",
                  ),
                ],
              ),
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
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.add_chart_rounded,
                  label: "Buat RPP",
                  onTap: () => Navigator.pushNamed(context, "/rpp/create"),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.edit_document,
                  label: "Revisi RPP",
                  onTap: () => Navigator.pushNamed(context, "/rpp"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
