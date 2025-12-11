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
        Text(
          "RPP Pending Review",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        Column(
          children: const [
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
        Text(
          "Statistik Sekolah",
          style: const TextStyle(
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
        Text(
          "Aksi Cepat",
          style: const TextStyle(
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
                icon: Icons.fact_check_rounded,
                label: "Review & Approve RPP",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: QuickActionButton(
                icon: Icons.file_download_rounded,
                label: "Export Semua RPP",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: QuickActionButton(
                icon: Icons.calendar_today_rounded,
                label: "Export Jadwal",
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: QuickActionButton(
                icon: Icons.campaign_rounded,
                label: "Buat Pengumuman",
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
