import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';
import '../widgets/weekly_table_guru.dart';
import '../widgets/weekly_table_adminkepsek.dart';

class WeeklyRosterExportPage extends StatelessWidget {
  final String role;

  const WeeklyRosterExportPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: role,
      selectedRoute: "/schedule",
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: _card(context),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // CARD WRAPPER
  // ======================================================
  Widget _card(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),

            if (role == "guru")
              const WeeklyTableGuru()
            else
              const WeeklyTableAdmin(),

            const SizedBox(height: 32),
            _exportButtons(context),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // HEADER
  // ======================================================
  Widget _header() {
    return Row(
      children: [
        Icon(Icons.table_chart_rounded, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          "Export Jadwal Mingguan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // ======================================================
  // EXPORT BUTTONS
  // ======================================================
  Widget _exportButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Export PDF berhasil")),
            );
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export PDF"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Export Excel berhasil")),
            );
          },
          icon: const Icon(Icons.grid_on),
          label: const Text("Export Excel"),
        ),
      ],
    );
  }
}
