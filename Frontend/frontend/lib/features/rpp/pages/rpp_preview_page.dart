import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/rpp_status_badge.dart';
import '../layout/rpp_layout.dart';
import '../../../core/services/rpp_revied_detail_service.dart';

class RppPreviewPage extends StatefulWidget {
  final String? mapel;
  final String? kelas;
  final String? bab;
  final String? status;
  final int? rppId;

  const RppPreviewPage({
    super.key,
    this.mapel,
    this.kelas,
    this.bab,
    this.status,
    this.rppId,
  });

  @override
  State<RppPreviewPage> createState() => _RppPreviewPageState();
}

class _RppPreviewPageState extends State<RppPreviewPage> {
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final rppId = widget.rppId ?? args?['rpp_id'] ?? args?['RPP_ID'];
    
    if (rppId != null) {
      _detailFuture = RppReviewDetailService.getDetail(
        rppId is int ? rppId : int.tryParse('$rppId') ?? 0,
      );
    } else {
      _detailFuture = Future.value({'success': false, 'data': null});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final res = snapshot.data ?? {};
          final data = res['data'] as Map<String, dynamic>? ?? {};

          if (res['success'] != true || data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(res['message'] ?? 'Gagal memuat detail RPP'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          return _buildContent(context, data);
        },
      ),
    );
  }

  // ==========================================================
  // MAIN CONTENT
  // ==========================================================
  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final mapel = data['Nama_Mata_Pelajaran'] ?? widget.mapel ?? '-';
    final kelas = data['Kelas'] ?? widget.kelas ?? '-';
    final bab = data['Bab_Materi'] ?? widget.bab ?? '-';
    final status = data['Status'] ?? widget.status ?? '-';

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
              Expanded(
                child: Text(
                  "Preview RPP – $mapel Kelas $kelas",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              RppStatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 30),

          _buildRppDocument(context, data, mapel, kelas, bab),
        ],
      ),
    );
  }

  // ==========================================================
  // RPP DOCUMENT (IDENTITAS + ISI RPP)
  // ==========================================================
  Widget _buildRppDocument(BuildContext context, Map<String, dynamic> data, String mapel, String kelas, String bab) {
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
          _infoRow("Nama Guru", data["Nama_Guru"] ?? "-"),
          _infoRow("Mata Pelajaran", mapel),
          _infoRow("Kelas / Semester", "$kelas / ${data["Semester"] ?? "-"}"),
          _infoRow("Bab / Materi", bab),

          const SizedBox(height: 28),

          // ===============================
          // KOMPETENSI DASAR & INTI
          // ===============================
          _sectionTitle("I. KOMPETENSI DASAR"),
          _longText(data["Kompetensi_Dasar"]),

          const SizedBox(height: 20),

          _sectionTitle("II. KOMPETENSI INTI"),
          _longText(data["Kompetensi_Inti"]),

          const SizedBox(height: 28),

          // ===============================
          // TUJUAN PEMBELAJARAN
          // ===============================
          _sectionTitle("III. TUJUAN PEMBELAJARAN"),
          _bulletList(data["Tujuan_Pembelajaran"]),

          const SizedBox(height: 28),

          // ===============================
          // KEGIATAN PEMBELAJARAN
          // ===============================
          _sectionTitle("IV. KEGIATAN PEMBELAJARAN"),

          const SizedBox(height: 14),
          _subHeader("A. Pendahuluan"),
          _longText(data["Pendahuluan"]),

          const SizedBox(height: 14),
          _subHeader("B. Inti"),
          _longText(data["Kegiatan_Inti"]),

          const SizedBox(height: 14),
          _subHeader("C. Penutup"),
          _longText(data["Penutup"]),

          const SizedBox(height: 28),

          // ===============================
          // ASESMEN
          // ===============================
          _sectionTitle("V. ASESMEN PEMBELAJARAN"),
          _longText(data["Asesmen_Pembelajaran"]),

          const SizedBox(height: 28),

          // ===============================
          // KOMPONEN TAMBAHAN
          // ===============================
          _sectionTitle("VI. METODE PEMBELAJARAN"),
          _longText(data["Metode_Pembelajaran"]),

          const SizedBox(height: 20),

          _sectionTitle("VII. MEDIA PEMBELAJARAN"),
          _longText(data["Media_Pembelajaran"]),

          const SizedBox(height: 20),

          _sectionTitle("VIII. SUMBER BELAJAR"),
          _longText(data["Sumber_Belajar"]),

          const SizedBox(height: 20),

          if ((data["Lampiran"] ?? "").toString().isNotEmpty)
            _sectionTitle("IX. LAMPIRAN"),

          if ((data["Lampiran"] ?? "").toString().isNotEmpty)
            _longText(data["Lampiran"]),
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
