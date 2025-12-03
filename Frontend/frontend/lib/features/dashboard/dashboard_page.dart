import 'package:flutter/material.dart';

import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';
import '../role_config/role_access.dart';

class DashboardPage extends StatelessWidget {
  /// Role user saat ini: "admin", "guru", "wakasek", "kepsek", "operator"
  final String role;

  const DashboardPage({super.key, this.role = "guru"});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          // TOP STATS
          _buildTopStats(role),

          const SizedBox(height: 30),

          // GRAFIK / ANALYTICS
          _buildAnalyticsSection(),

          const SizedBox(height: 30),

          // SHORTCUT FITUR
          _buildFeatureShortcuts(context, role),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ===========================================================
  // TOP STAT CARDS
  // ===========================================================
  Widget _buildTopStats(String role) {
    List<_DashStat> stats = [];

    if (RoleAccess.canSeeAllRPP(role)) {
      stats = [
        _DashStat("Guru", "48"),
        _DashStat("Jadwal", "192"),
        _DashStat("RPP", "73"),
        _DashStat("Kelas", "24"),
      ];
    } else if (role == "guru") {
      stats = [
        _DashStat("Mengajar Hari Ini", "2"),
        _DashStat("Total RPP", "6"),
      ];
    } else {
      stats = [_DashStat("Jadwal", "192"), _DashStat("RPP", "73")];
    }

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: stats
          .map((s) => _StatCard(title: s.title, value: s.value))
          .toList(),
    );
  }

  // ===========================================================
  // ANALYTICS / GRAPH SECTION (VISUAL ONLY)
  // ===========================================================
  Widget _buildAnalyticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Aktivitas Mingguan", style: AppTypography.h3),
          const SizedBox(height: 20),

          // Grafik placeholder
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = (index + 2) * 15;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: height.toDouble(),
                    decoration: BoxDecoration(
                      // withOpacity -> withValues (supaya tidak warning)
                      color: AppColors.accent.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // FEATURE SHORTCUT CARDS (VISUAL MENU)
  // ===========================================================
  Widget _buildFeatureShortcuts(BuildContext context, String role) {
    final List<_FeatureData> list = [];

    if (RoleAccess.canManageSchedule(role)) {
      list.add(
        _FeatureData("Kelola Jadwal", Icons.schedule_outlined, "/schedule"),
      );
    }

    if (RoleAccess.canEditRPP(role)) {
      list.add(_FeatureData("RPP Saya", Icons.menu_book_outlined, "/rpp/my"));
    }

    if (RoleAccess.canReviewRPP(role)) {
      list.add(_FeatureData("Review RPP", Icons.task_outlined, "/rpp/review"));
    }

    if (RoleAccess.canManageUsers(role)) {
      list.add(_FeatureData("Manajemen User", Icons.people_outline, "/users"));
    }

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: list
          .map(
            (data) => _FeatureCard(
              data: data,
              onTap: () => Navigator.pushNamed(context, data.route),
            ),
          )
          .toList(),
    );
  }
}

// ===================================================================
// COMPONENTS
// ===================================================================

class _DashStat {
  final String title;
  final String value;
  _DashStat(this.title, this.value);
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.small),
          const SizedBox(height: 14),
          Text(value, style: AppTypography.h2),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  final VoidCallback onTap;

  const _FeatureCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 240,
        height: 120,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            // withOpacity -> withValues supaya tidak warning
            color: AppColors.accent.withValues(alpha: 0.3),
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, size: 28, color: AppColors.secondary),
            const SizedBox(height: 12),
            Text(data.title, style: AppTypography.body),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final String title;
  final IconData icon;
  final String route;

  _FeatureData(this.title, this.icon, this.route);
}
