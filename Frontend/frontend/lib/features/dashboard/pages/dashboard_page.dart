import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../config/theme/typography.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 850;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 TITLE
          Text(
            "Dashboard",
            style: AppTypography.h1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 26),

          // 📊 STAT CARDS
          Wrap(
            spacing: 22,
            runSpacing: 22,
            children:
                [
                  _statCard("Guru Aktif", "42", Icons.person),
                  _statCard("Siswa Aktif", "390", Icons.school),
                  _statCard("RPP Tersusun", "112", Icons.description),
                  _statCard("Jadwal Minggu Ini", "18", Icons.calendar_month),
                ].map((card) {
                  return SizedBox(
                    width: isMobile ? double.infinity : 280,
                    child: card,
                  );
                }).toList(),
          ),

          const SizedBox(height: 32),

          // ⚡ QUICK ACTIONS
          Text(
            "Aksi Cepat",
            style: AppTypography.h2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            children:
                [
                      _quickAction(
                        context,
                        "Buat RPP",
                        Icons.add_chart,
                        AppColors.primary,
                      ),
                      _quickAction(
                        context,
                        "Buat Jadwal",
                        Icons.schedule,
                        AppColors.secondary,
                      ),
                      _quickAction(
                        context,
                        "Lihat RPP",
                        Icons.folder_open,
                        AppColors.accent,
                      ),
                      _quickAction(
                        context,
                        "Kelola Pengguna",
                        Icons.people,
                        AppColors.cardBlue,
                      ),
                    ]
                    .map(
                      (item) => isMobile
                          ? SizedBox(width: double.infinity, child: item)
                          : item,
                    )
                    .toList(),
          ),

          const SizedBox(height: 32),

          // 🕒 RECENT ACTIVITY
          Text(
            "Aktivitas Terbaru",
            style: AppTypography.h2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 16),

          _recentActivityContainer(),
        ],
      ),
    );
  }

  // =====================================================================
  // 📊 STAT CARD
  // =====================================================================

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.h2.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              Text(
                title,
                style: AppTypography.small.copyWith(color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // ⚡ QUICK ACTION BUTTON
  // =====================================================================

  Widget _quickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // 🕒 RECENT ACTIVITY LIST
  // =====================================================================

  Widget _recentActivityContainer() {
    List<String> items = [
      "Guru Andi mengupload RPP IPA kelas 8",
      "Jadwal kelas IX-B diperbarui",
      "RPP Matematika direvisi oleh Bu Wati",
      "Pengguna baru ditambahkan: Pak Joko",
    ];

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.circle, color: AppColors.primary, size: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
