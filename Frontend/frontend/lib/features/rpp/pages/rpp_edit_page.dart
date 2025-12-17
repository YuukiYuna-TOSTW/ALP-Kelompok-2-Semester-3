import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

import '../layout/rpp_layout.dart';
import '../components/rpp_revision_panel.dart';
import '../components/rpp_section_editor.dart';
import '../components/rpp_metadata_form.dart';
import '../components/rpp_ai_dialog.dart';
import '../components/rpp_attachment_uploader.dart';
import '../../../core/services/guru_rpp_edit_service.dart'; // ✅ tambah

class RppEditPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const RppEditPage({super.key, this.data});

  @override
  State<RppEditPage> createState() => _RppEditPageState();
}

class _RppEditPageState extends State<RppEditPage> {
  bool readOnly = false;
  bool _saving = false; // ✅ tambah
  int? _rppId; // ✅ simpan ID RPP

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
  // LOAD DATA — ambil dari detail API
  // ============================================================
  void _loadData() async {
    final data = widget.data;
    if (data == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data RPP tidak ditemukan')),
        );
      }
      return;
    }

    // ✅ PRIORITAS 1: Ambil dari key RPP_ID yang eksplisit
    final idRaw = data['RPP_ID'];
    
    if (idRaw != null) {
      _rppId = idRaw is int ? idRaw : int.tryParse('$idRaw');
      print('✅ RPP_ID ditemukan: $_rppId'); // ✅ debug log
    } else {
      print('❌ RPP_ID tidak ditemukan di arguments'); // ✅ debug log
    }

    final detail = data['detail'] as Map<String, dynamic>?;
    if (detail != null) {
      _populateFromDetail(detail);
    } else {
      // fallback: ambil dari data list (kurang lengkap)
      _populateFromData(data);
    }

    readOnly = (safe(data["status"]) == "Menunggu Review");
  }

  void _populateFromDetail(Map<String, dynamic> detail) {
    // Metadata
    mapelCtrl.text = safe(detail["Nama_Mata_Pelajaran"]);
    kelasCtrl.text = safe(detail["Kelas"]);
    babCtrl.text = safe(detail["Bab/Materi"]);
    semesterCtrl.text = safe(detail["Semester"]);

    // Isi RPP
    kdCtrl.text = safe(detail["Kompetensi_Dasar"]);
    kiCtrl.text = safe(detail["Kompetensi_Inti"]);
    tujuanCtrl.text = safe(detail["Tujuan_Pembelajaran"]);

    pendahuluanCtrl.text = safe(detail["Pendahuluan"]);
    intiCtrl.text = safe(detail["Kegiatan_Inti"]);
    penutupCtrl.text = safe(detail["Penutup"]);

    materiCtrl.text = safe(detail["Materi_Pembelajaran"]);
    asesmenCtrl.text = safe(detail["Asesmen_Pembelajaran"]);
    metodeCtrl.text = safe(detail["Metode_Pembelajaran"]);
    mediaCtrl.text = safe(detail["Media_Pembelajaran"]);
    sumberCtrl.text = safe(detail["Sumber_Belajar"]);

    final lamp = detail["Lampiran"];
    if (lamp is String && lamp.isNotEmpty && lamp != '-') {
      attachments = lamp.split(',').map((e) => e.trim()).toList();
    }

    final raw = detail["revisi"] ?? detail["revisionNotes"];
    if (raw is List) {
      revisionNotes = raw.whereType<Map<String, dynamic>>().toList();
    }
  }

  void _populateFromData(Map<String, dynamic> data) {
    mapelCtrl.text = safe(data["mapel"]);
    kelasCtrl.text = safe(data["kelas"]);
    babCtrl.text = safe(data["bab"]);
    semesterCtrl.text = safe(data["semester"]);

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

    final raw = data["revisi"] ?? data["revisionNotes"];
    if (raw is List) {
      revisionNotes = raw.whereType<Map<String, dynamic>>().toList();
    }
  }

  // ============================================================
  // SUBMIT UPDATE
  // ============================================================
  Future<void> _submitUpdate({required String newStatus}) async {
    // ✅ Validasi RPP_ID sebelum submit
    if (_rppId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID RPP tidak ditemukan. Tidak dapat menyimpan perubahan.')),
        );
      }
      return;
    }
    
    if (_rppId! <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID RPP tidak valid')),
        );
      }
      return;
    }
    
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
      'Status': newStatus,
    };

    // ✅ Debug log sebelum submit
    print('=== SUBMIT UPDATE RPP ===');
    print('RPP_ID: $_rppId');
    print('Status Baru: $newStatus');
    print('Payload: $payload');

    final res = await GuruRppEditService.updateRpp(_rppId!, payload);
    
    // ✅ Debug response
    print('Response: $res');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Terjadi kesalahan'),
          backgroundColor: res['success'] == true ? Colors.green : Colors.red,
        ),
      );
      
      if (res['success'] == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          // ✅ Kembali ke list dan reload
          Navigator.pushReplacementNamed(context, "/rpp");
        }
      }
    }
    
    if (mounted) setState(() => _saving = false);
  }

  // ============================================================
  // PAGE CONTENT (UI tidak berubah)
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
          onPressed: _saving
              ? null
              : () => _submitUpdate(newStatus: 'Menunggu Review'), // ✅ sama dengan Rpp::STATUS_MENUNGGU_REVIEW
          child: Text(_saving ? "Menyimpan..." : "Simpan Perubahan"),
        ),

        const SizedBox(width: 12),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          onPressed: _saving
              ? null
              : () => _submitUpdate(newStatus: 'Menunggu Review'), // ✅ sama dengan Rpp::STATUS_MENUNGGU_REVIEW
          child: const Text("Kirim untuk Review"),
        ),
      ],
    );
  }
}
