import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/rpp_layout.dart';

class RppReviewPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RppReviewPage({super.key, this.data});

  @override
  State<RppReviewPage> createState() => _RppReviewPageState();
}

class _RppReviewPageState extends State<RppReviewPage> {
  final Map<String, TextEditingController> notes = {
    "KD": TextEditingController(),
    "KI": TextEditingController(),
    "Tujuan": TextEditingController(),
    "Pendahuluan": TextEditingController(),
    "Inti": TextEditingController(),
    "Penutup": TextEditingController(),
    "Catatan Umum": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    final rpp = widget.data ?? {};

    return RppLayout(
      selectedRoute: "/kepsek/rpp",
      role: "kepsek",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: _buildCard(context, rpp),
        ),
      ),
    );
  }

  // =====================================================
  // MAIN CARD
  // =====================================================
  Widget _buildCard(BuildContext context, Map<String, dynamic> rpp) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _header(context),
          SizedBox(
            height: MediaQuery.of(context).size.height - 260,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section("KD", "Kompetensi Dasar", rpp["kd"]),
                  _section("KI", "Kompetensi Inti", rpp["ki"]),
                  _section("Tujuan", "Tujuan Pembelajaran", rpp["tujuan"]),
                  _section("Pendahuluan", "Pendahuluan", rpp["pendahuluan"]),
                  _section("Inti", "Kegiatan Inti", rpp["inti"]),
                  _section("Penutup", "Penutup", rpp["penutup"]),
                  _section("Catatan Umum", "Catatan Tambahan", ""),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _actionButtons(context),
        ],
      ),
    );
  }

  // =====================================================
  // HEADER DENGAN BACK + TITLE + SETUJUI
  // =====================================================
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Tombol Back
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Text(
              "Review RPP Guru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),

          // Tombol Setujui di header
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => _submit(context, "Disetujui"),
            child: const Text(
              "Setujui",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SECTION
  // =====================================================
  Widget _section(String key, String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 5),

        // Konten RPP
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(content?.toString() ?? "-"),
        ),

        const SizedBox(height: 10),

        // Catatan Reviewer
        TextField(
          controller: notes[key],
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: "Catatan Reviewer",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // =====================================================
  // BUTTONS BAWAH (REVISI)
  // =====================================================
  Widget _actionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
              ),
              onPressed: () => _submit(context, "Revisi"),
              child: const Text(
                "Minta Revisi",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SUBMISSION HANDLER
  // =====================================================
  void _submit(BuildContext context, String status) {
    Navigator.pop(context, {
      "status": status,
      "notes": notes.map((key, ctrl) => MapEntry(key, ctrl.text)),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == "Disetujui" ? "RPP disetujui." : "RPP diminta revisi.",
        ),
      ),
    );
  }
}
