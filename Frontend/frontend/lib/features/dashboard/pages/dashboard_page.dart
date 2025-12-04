import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../config/theme/typography.dart';

class DashboardPage extends StatelessWidget {
  final String role;

  const DashboardPage({super.key, this.role = "admin"});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================================================
          // HEADER
          // =======================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dashboard Admin", style: AppTypography.h2),
              Text(
                "SMP Negeri 1 Bontonompo Selatan",
                style: AppTypography.small,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // =======================================================
          // QUICK STATS
          // =======================================================
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              _StatCard(title: "Total Guru", value: "48"),
              _StatCard(title: "Total Kelas", value: "24"),
              _StatCard(title: "Total Jadwal", value: "192"),
              _StatCard(title: "Total RPP", value: "73"),
            ],
          ),

          const SizedBox(height: 40),

          // =======================================================
          // QUICK ACTIONS
          // =======================================================
          Text("Aksi Cepat", style: AppTypography.h3),
          const SizedBox(height: 16),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              _MenuCard(title: "Buat Jadwal", icon: Icons.schedule),
              _MenuCard(title: "Kelola Guru", icon: Icons.people),
              _MenuCard(title: "Kelola Kelas", icon: Icons.class_),
              _MenuCard(title: "RPP Template", icon: Icons.article_outlined),
              _MenuCard(title: "Export Jadwal", icon: Icons.download),
              _MenuCard(title: "Export RPP", icon: Icons.download_for_offline),
            ],
          ),

          const SizedBox(height: 40),

          // =======================================================
          // RECENT UPDATES
          // =======================================================
          Text("Aktivitas Terbaru", style: AppTypography.h3),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: const [
                _RecentTile("Guru A mengupload RPP kelas 8A"),
                _RecentTile("Jadwal kelas 9B diperbarui"),
                _RecentTile("Guru baru ditambah: Ibu Sinta"),
                _RecentTile("Template RPP direvisi oleh Admin"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// COMPONENTS
// ===================================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.small),
          const Spacer(),
          Text(value, style: AppTypography.h2),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _MenuCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.secondary),
          const SizedBox(height: 14),
          Text(title, style: AppTypography.body),
        ],
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final String text;

  const _RecentTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10, color: AppColors.secondary),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.body),
        ],
      ),
    );
  }
}
