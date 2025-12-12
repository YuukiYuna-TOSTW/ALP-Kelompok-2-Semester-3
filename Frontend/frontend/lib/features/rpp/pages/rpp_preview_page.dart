import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/rpp_status_badge.dart';
import '../layout/rpp_layout.dart';

class RppPreviewPage extends StatelessWidget {
  final String mapel;
  final String kelas;
  final String bab;
  final String status;

  const RppPreviewPage({
    super.key,
    required this.mapel,
    required this.kelas,
    required this.bab,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: _buildContent(context, data),
    );
  }

  // ==========================================================
  // MAIN CONTENT
  // ==========================================================
  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BACK BUTTON
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text("Kembali"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
          ),

          const SizedBox(height: 22),

          // TITLE & STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Preview RPP – $mapel Kelas $kelas",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              RppStatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 30),

          _buildRppDocument(context, data),
        ],
      ),
    );
  }

  // ==========================================================
  // RPP DOCUMENT (IDENTITAS + ISI RPP)
  // ==========================================================
  Widget _buildRppDocument(BuildContext context, Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader("RENCANA PELAKSANAAN PEMBELAJARAN"),

          // ===============================
          // IDENTITAS
          // ===============================
          _infoRow("Nama Guru", data["guru"] ?? "Budi Santoso, S.Pd."),
          _infoRow("NIP", data["nip"] ?? "19780212 200501 1 001"),
          _infoRow("Mata Pelajaran", mapel),
          _infoRow("Kelas / Semester", "$kelas / ${data["semester"] ?? "-"}"),
          _infoRow("Bab / Materi", bab),
          _infoRow("Pertemuan Ke", data["pertemuan"] ?? "-"),
          _infoRow("Alokasi Waktu", data["alokasi"] ?? "-"),

          const SizedBox(height: 28),

          // ===============================
          // TUJUAN PEMBELAJARAN
          // ===============================
          _sectionTitle("I. TUJUAN PEMBELAJARAN"),
          _bulletList(data["tujuan"]),

          const SizedBox(height: 28),

          // ===============================
          // KEGIATAN PEMBELAJARAN (OPTION 2)
          // ===============================
          _sectionTitle("II. KEGIATAN PEMBELAJARAN"),

          const SizedBox(height: 14),
          _subHeader("A. Pendahuluan"),
          _longText(data["pendahuluan"]),

          const SizedBox(height: 14),
          _subHeader("B. Inti"),
          _longText(data["inti"]),

          const SizedBox(height: 14),
          _subHeader("C. Penutup"),
          _longText(data["penutup"]),

          const SizedBox(height: 28),

          // ===============================
          // ASESMEN
          // ===============================
          _sectionTitle("III. ASESMEN PEMBELAJARAN"),
          _longText(data["asesmen"]),

          const SizedBox(height: 28),

          // ===============================
          // KOMPONEN TAMBAHAN
          // ===============================
          _sectionTitle("IV. METODE PEMBELAJARAN"),
          _longText(data["metode"]),

          const SizedBox(height: 20),

          _sectionTitle("V. MEDIA PEMBELAJARAN"),
          _longText(data["media"]),

          const SizedBox(height: 20),

          _sectionTitle("VI. SUMBER BELAJAR"),
          _longText(data["sumber"]),

          const SizedBox(height: 20),

          if ((data["lampiran"] ?? []).isNotEmpty)
            _sectionTitle("VII. LAMPIRAN"),

          if ((data["lampiran"] ?? []).isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (data["lampiran"] as List<String>).map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("• $e"),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(child: Text(":  $value")),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _subHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _bulletList(String? text) {
    if (text == null || text.trim().isEmpty) return const Text("-");

    final lines = text.split("\n");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text("• $e", style: const TextStyle(fontSize: 15)),
        );
      }).toList(),
    );
  }

  Widget _longText(String? text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        text?.trim().isEmpty ?? true ? "-" : text!,
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }
}
