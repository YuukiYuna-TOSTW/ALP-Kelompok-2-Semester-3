import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';

class AdminDashboardContent extends StatelessWidget {
  const AdminDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // ⭐ STATISTIK SISTEM
        // =====================================================
        const Text(
          "Statistik Sistem",
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
                icon: Icons.person_rounded,
                value: "48",
                title: "Total Guru",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.school_rounded,
                value: "24",
                title: "Total Kelas",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.book_rounded,
                value: "16",
                title: "Mata Pelajaran",
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: const [
            Expanded(
              child: StatCard(
                icon: Icons.calendar_month_rounded,
                value: "192",
                title: "Total Jadwal",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: StatCard(
                icon: Icons.menu_book_rounded,
                value: "73",
                title: "Total RPP",
              ),
            ),
            SizedBox(width: 14),
            Expanded(child: SizedBox()),
          ],
        ),

        const SizedBox(height: 32),

        // =====================================================
        // ⭐ AKSI CEPAT (SAMA DENGAN KEPSEK)
        // =====================================================
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
                icon: Icons.event_available_rounded,
                label: "Buat Kegiatan",
                onTap: () {
                  Navigator.pushNamed(context, "/calendar");
                },
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: QuickActionButton(
                icon: Icons.calendar_today_rounded,
                label: "Export Jadwal",
                onTap: () {
                  Navigator.pushNamed(context, "/schedule/export");
                },
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: QuickActionButton(
                icon: Icons.campaign_rounded,
                label: "Buat Pengumuman",
                onTap: () {
                  Navigator.pushNamed(context, "/announcement/create");
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
