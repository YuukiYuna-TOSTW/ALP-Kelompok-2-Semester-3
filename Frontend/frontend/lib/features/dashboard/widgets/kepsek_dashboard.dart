import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';
import '../components/rpp_review_card.dart';

class KepsekDashboardContent extends StatelessWidget {
  const KepsekDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // ===============================
        // ⭐ RPP PENDING REVIEW
        // ===============================
        const Text(
          "RPP Pending Review",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        const Column(
          children: [
            RppReviewCard(
              subject: "Matematika",
              className: "8A",
              teacher: "Bpk. Rahman",
              time: "10 menit lalu",
            ),
            SizedBox(height: 10),
            RppReviewCard(
              subject: "PJOK",
              className: "9C",
              teacher: "Bu Tika",
              time: "32 menit lalu",
            ),
            SizedBox(height: 10),
            RppReviewCard(
              subject: "Bahasa Indonesia",
              className: "7B",
              teacher: "Bu Nisa",
              time: "1 jam lalu",
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ===============================
        // ⭐ STATISTIK SEKOLAH
        // ===============================
        const Text(
          "Statistik Sekolah",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        const Row(
          children: [
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
                icon: Icons.menu_book_rounded,
                value: "12",
                title: "RPP Pending",
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
                icon: Icons.event_available_rounded,
                label: "Buat Kegiatan Baru",
                onTap: () {
                  Navigator.pushNamed(context, "/kegiatan/create");
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
