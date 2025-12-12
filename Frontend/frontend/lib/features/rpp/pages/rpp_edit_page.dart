import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

import '../layout/rpp_layout.dart';
import '../components/rpp_revision_panel.dart';
import '../components/rpp_section_editor.dart';
import '../components/rpp_metadata_form.dart';
import '../components/rpp_ai_dialog.dart';
import '../components/rpp_attachment_uploader.dart';

class RppEditPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RppEditPage({super.key, this.data});

  @override
  State<RppEditPage> createState() => _RppEditPageState();
}

class _RppEditPageState extends State<RppEditPage> {
  bool readOnly = false;

  // Controller metadata
  final mapelCtrl = TextEditingController();
  final kelasCtrl = TextEditingController();
  final babCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();

  // Controller isi RPP
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
  List<Map<String, dynamic>> revisionNotes = [];

  // Utility agar semua input aman
  String safe(dynamic value) => value?.toString() ?? "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ============================================================
  // LOAD DATA — FIXED (AMAN TANPA DUMMY)
  // ============================================================
  void _loadData() {
    final data = widget.data;
    if (data == null) return;

    readOnly = (safe(data["status"]) == "Menunggu Review");

    // Metadata
    mapelCtrl.text = safe(data["mapel"]);
    kelasCtrl.text = safe(data["kelas"]);
    babCtrl.text = safe(data["bab"]);
    semesterCtrl.text = safe(data["semester"]);

    // Isi RPP
    kdCtrl.text = safe(data["kd"]);
    kiCtrl.text = safe(data["ki"]);
    tujuanCtrl.text = safe(data["tujuan"]);

    pendahuluanCtrl.text = safe(data["pendahuluan"]);
    intiCtrl.text = safe(data["inti"]);
    penutupCtrl.text = safe(data["penutup"]);

    materiCtrl.text = safe(data["materi"]);
    asesmenCtrl.text = safe(data["asesmen"]);
    metodeCtrl.text = safe(data["metode"]);
    mediaCtrl.text = safe(data["media"]);
    sumberCtrl.text = safe(data["sumber"]);

    attachments = List<String>.from(data["lampiran"] ?? []);

    // ========================= REVISION FIX =========================
    final raw = data["revisi"] ?? data["revisionNotes"];

    if (raw is List) {
      // Ambil hanya Map agar tidak error
      revisionNotes = raw.whereType<Map<String, dynamic>>().toList();
    } else {
      revisionNotes = []; // TANPA DUMMY
    }
  }

  // ============================================================
  // PAGE CONTENT
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        if (revisionNotes.isNotEmpty) RppRevisionPanel(notes: revisionNotes),

        const SizedBox(height: 20),

        _buildCard(),
        const SizedBox(height: 30),

        _buildButtonBar(),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================
  Widget _buildCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
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
                const SizedBox(width: 8),
                const Text(
                  "Edit RPP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // BODY
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Informasi Dasar RPP"),
                const SizedBox(height: 12),

                RppMetadataForm(
                  mapelCtrl: mapelCtrl,
                  kelasCtrl: kelasCtrl,
                  babCtrl: babCtrl,
                  semesterCtrl: semesterCtrl,
                ),

                const SizedBox(height: 24),

                _label("Isi RPP"),
                const SizedBox(height: 12),

                _section("Kompetensi Dasar", kdCtrl),
                _section("Kompetensi Inti", kiCtrl),
                _section("Tujuan Pembelajaran", tujuanCtrl),

                const SizedBox(height: 8),
                _label("Kegiatan Pembelajaran"),
                const SizedBox(height: 10),

                _section("Pendahuluan", pendahuluanCtrl),
                _section("Kegiatan Inti", intiCtrl),
                _section("Penutup", penutupCtrl),

                _section("Materi Pembelajaran", materiCtrl),
                _section("Asesmen Pembelajaran", asesmenCtrl),
                _section("Metode Pembelajaran", metodeCtrl),
                _section("Media Pembelajaran", mediaCtrl),
                _section("Sumber Belajar", sumberCtrl),

                const SizedBox(height: 20),
                _label("Lampiran (Opsional)"),
                const SizedBox(height: 10),

                RppAttachmentUploader(
                  files: attachments,
                  onAddFile: (name) => setState(() => attachments.add(name)),
                  onRemove: (i) => setState(() => attachments.removeAt(i)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION BUILDER
  // ============================================================
  Widget _section(String title, TextEditingController controller) {
    return RppSectionEditor(
      title: title,
      controller: controller,
      readOnly: readOnly,
      onAiPressed: () => showRppAiDialog(context, controller: controller),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  // ============================================================
  // BUTTON BAR
  // ============================================================
  Widget _buildButtonBar() {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Perubahan disimpan!")),
            );
          },
          child: const Text("Simpan Perubahan"),
        ),

        const SizedBox(width: 12),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("RPP dikirim untuk review!")),
            );
          },
          child: const Text("Kirim untuk Review"),
        ),
      ],
    );
  }
}
