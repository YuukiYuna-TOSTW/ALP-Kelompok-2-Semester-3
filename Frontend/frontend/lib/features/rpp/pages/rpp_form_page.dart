import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../core/services/rpp_service.dart'; // ✅ tambah

import '../layout/rpp_layout.dart';
import '../components/rpp_ai_dialog.dart';
import '../components/rpp_metadata_form.dart';
import '../components/rpp_section_editor.dart';
import '../components/rpp_attachment_uploader.dart';

class RppFormPage extends StatefulWidget {
  const RppFormPage({super.key});

  @override
  State<RppFormPage> createState() => _RppFormPageState();
}

class _RppFormPageState extends State<RppFormPage> {
  // ============================== METADATA ==============================
  final mapelCtrl = TextEditingController();
  final kelasCtrl = TextEditingController();
  final babCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();

  // ============================== RPP CONTENT ==============================
  final kdCtrl = TextEditingController();
  final kiCtrl = TextEditingController();
  final tujuanCtrl = TextEditingController();

  final pendahuluanCtrl = TextEditingController();
  final intiCtrl = TextEditingController();
  final penutupCtrl = TextEditingController();

  final materiCtrl = TextEditingController();
  final asesmenCtrl = TextEditingController();
  final metodeCtrl = TextEditingController();
  final mediaCtrl = TextEditingController();
  final sumberCtrl = TextEditingController();

  List<String> attachments = [];

  bool _saving = false; // ✅ tambah

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RppLayout(
          role: "guru",
          selectedRoute: "/rpp",
          content: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: _buildContent(context),
            ),
          ),
        ),

        // ============================================================
        // ⭐ FLOATING CHATBOT BUTTON (selalu terlihat)
        // ============================================================
        Positioned(
          bottom: 26,
          right: 26,
          child: GestureDetector(
            onTap: () {
              // Bisa diarahkan ke halaman chatbot
              Navigator.pushNamed(context, "/assistant");
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================================
  // MAIN CONTENT
  // ======================================================================
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainCard(),
        const SizedBox(height: 30),
        _buildActionButtons(),
      ],
    );
  }

  // ======================================================================
  // CARD WITH HEADER + BACK BUTTON
  // ======================================================================
  Widget _buildMainCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------ HEADER BIRU ------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Buat RPP Baru",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ------------ BODY FORM ------------
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _blueLabel("Informasi Dasar RPP"),
                const SizedBox(height: 16),

                RppMetadataForm(
                  mapelCtrl: mapelCtrl,
                  kelasCtrl: kelasCtrl,
                  babCtrl: babCtrl,
                  semesterCtrl: semesterCtrl,
                ),

                const SizedBox(height: 28),
                _blueLabel("Isi RPP"),
                const SizedBox(height: 18),

                _editor("Kompetensi Dasar", kdCtrl),
                _editor("Kompetensi Inti", kiCtrl),
                _editor("Tujuan Pembelajaran", tujuanCtrl),

                _sectionLabel("Kegiatan Pembelajaran"),
                const SizedBox(height: 12),

                _editor("Pendahuluan", pendahuluanCtrl),
                _editor("Kegiatan Inti", intiCtrl),
                _editor("Penutup", penutupCtrl),

                const SizedBox(height: 18),

                _editor("Materi Pembelajaran", materiCtrl),
                _editor("Asesmen Pembelajaran", asesmenCtrl),
                _editor("Metode Pembelajaran", metodeCtrl),
                _editor("Media Pembelajaran", mediaCtrl),
                _editor("Sumber Belajar", sumberCtrl),

                const SizedBox(height: 24),

                _blueLabel("Lampiran"),
                const SizedBox(height: 12),

                RppAttachmentUploader(
                  files: attachments,
                  onRemove: (i) => setState(() => attachments.removeAt(i)),
                  onAddFile: (name) => setState(() => attachments.add(name)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  // LABEL HELPERS
  // ======================================================================
  Widget _blueLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _editor(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(title),
        const SizedBox(height: 6),

        RppSectionEditor(
          title: "",
          controller: controller,
          onAiPressed: () => showRppAiDialog(context, controller: controller),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ======================================================================
  // BUTTON BAR
  // ======================================================================
  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _saving ? null : () => _submit(draft: true), // ✅ Simpan Draft
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: Text(_saving ? "Menyimpan..." : "Simpan Draft"),
        ),

        const SizedBox(width: 12),

      ],
    );
  }

  Future<void> _submit({required bool draft}) async {
    if (_saving) return;
    setState(() => _saving = true);

    final payload = {
      'Nama_Mata_Pelajaran': mapelCtrl.text.trim(),
      'Kelas': kelasCtrl.text.trim(),
      'Semester': semesterCtrl.text.trim(),
      'Bab/Materi': babCtrl.text.trim(),
      'Kompetensi_Dasar': kdCtrl.text.trim().isNotEmpty ? kdCtrl.text.trim() : '-',
      'Kompetensi_Inti': kiCtrl.text.trim().isNotEmpty ? kiCtrl.text.trim() : '-',
      'Tujuan_Pembelajaran': tujuanCtrl.text.trim().isNotEmpty ? tujuanCtrl.text.trim() : '-',
      'Pendahuluan': pendahuluanCtrl.text.trim().isNotEmpty ? pendahuluanCtrl.text.trim() : '-',
      'Kegiatan_Inti': intiCtrl.text.trim().isNotEmpty ? intiCtrl.text.trim() : '-',
      'Penutup': penutupCtrl.text.trim().isNotEmpty ? penutupCtrl.text.trim() : '-',
      'Materi_Pembelajaran': materiCtrl.text.trim().isNotEmpty ? materiCtrl.text.trim() : '-',
      'Asesmen_Pembelajaran': asesmenCtrl.text.trim().isNotEmpty ? asesmenCtrl.text.trim() : '-',
      'Metode_Pembelajaran': metodeCtrl.text.trim().isNotEmpty ? metodeCtrl.text.trim() : '-',
      'Media_Pembelajaran': mediaCtrl.text.trim().isNotEmpty ? mediaCtrl.text.trim() : '-',
      'Sumber_Belajar': sumberCtrl.text.trim().isNotEmpty ? sumberCtrl.text.trim() : '-',
      'Lampiran': attachments.isNotEmpty ? attachments.join(', ') : '-',
      'Catatan_Tambahan': '-',
      'Status': draft ? 'Minta Revisi' : 'Menunggu Review', // ✅ draft/kirim
    };

    final res = await RppService.createRpp(payload: payload, namaUser: 'Kelompok2Guru');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? '')),
      );
      if (res['success'] == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pushReplacementNamed(context, "/rpp");
      }
    }
    if (mounted) setState(() => _saving = false);
  }
}
