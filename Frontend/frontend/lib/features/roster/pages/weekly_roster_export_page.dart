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
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _card(context),
        ),
      ),
    );
  }

  // ======================================================
  // CARD BESAR (HEADER MENTOK + CONTENT)
  // ======================================================
  Widget _card(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(context),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TABLE =================
                SizedBox(
                  width: double.infinity, // ⬅️ FULL WIDTH
                  child: role == "guru"
                      ? const WeeklyTableGuru()
                      : const WeeklyTableAdmin(),
                ),

                const SizedBox(height: 32),

                // ================= BUTTONS =================
                _exportButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // HEADER (PRIMARY + BACK)
  // ======================================================
  Widget _cardHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "Kembali",
          ),
          const SizedBox(width: 6),
          const Icon(Icons.table_chart_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          const Text(
            "Export Jadwal Mingguan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
        ),
        const SizedBox(width: 14),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Export Excel berhasil")),
            );
          },
          icon: const Icon(Icons.grid_on),
          label: const Text("Export Excel"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
        ),
      ],
    );
  }
}
