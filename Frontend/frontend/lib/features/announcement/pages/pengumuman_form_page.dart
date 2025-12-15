import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class PengumumanFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const PengumumanFormPage({super.key, this.data});

  @override
  State<PengumumanFormPage> createState() => _PengumumanFormPageState();
}

class _PengumumanFormPageState extends State<PengumumanFormPage> {
  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final scheduledDateCtrl = TextEditingController();

  List<String> selectedAudience = [];
  String priority = "Sedang";
  bool schedule = false;
  List<PlatformFile> attachments = [];

  final List<String> guruList = ["Bu Sinta", "Pak Amir", "Bu Ayu", "Bu Lina"];

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      final d = widget.data!;
      titleCtrl.text = d["judul"] ?? "";
      bodyCtrl.text = d["isi"] ?? "";
      priority = d["prioritas"] ?? "Sedang";

      if (d["target"] is List) {
        selectedAudience = List<String>.from(d["target"]);
      }

      if (d["jadwal"] != null && d["jadwal"] != "") {
        schedule = true;
        scheduledDateCtrl.text = d["jadwal"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.data != null;

    return RppLayout(
      role: "kepsek",
      selectedRoute: "/announcement",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildCard(isEdit),
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================
  Widget _buildCard(bool isEdit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _header(isEdit),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section("Judul Pengumuman"),
                _field(titleCtrl, "Masukkan judul"),

                _section("Isi Pengumuman"),
                _field(bodyCtrl, "Tulis isi pengumuman...", maxLines: 6),

                _section("Tujuan Pengumuman"),
                _audienceSelector(),

                _section("Prioritas"),
                _prioritySelector(),

                _section("Lampiran"),
                _attachmentUploader(),

                _section("Tanggal Publikasi"),
                _scheduleSelector(),

                const SizedBox(height: 36),
                _buttons(isEdit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _header(bool isEdit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            isEdit ? "Edit Pengumuman" : "Buat Pengumuman",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================
  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 26),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================
  Widget _field(TextEditingController ctrl, String hint, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  // ============================================================
  // AUDIENCE
  // ============================================================
  Widget _audienceSelector() {
    return Column(
      children: [
        CheckboxListTile(
          value: selectedAudience.contains("Semua Guru"),
          onChanged: (v) {
            setState(() {
              selectedAudience = v == true ? ["Semua Guru"] : <String>[];
            });
          },
          title: const Text("Semua Guru"),
        ),
        ...guruList.map(
          (g) => CheckboxListTile(
            value: selectedAudience.contains(g),
            onChanged: (v) {
              setState(() {
                v == true
                    ? selectedAudience.add(g)
                    : selectedAudience.remove(g);
                selectedAudience.remove("Semua Guru");
              });
            },
            title: Text(g),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRIORITY
  // ============================================================
  Widget _prioritySelector() {
    return DropdownButtonFormField<String>(
      value: priority,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: const [
        DropdownMenuItem(value: "Rendah", child: Text("Rendah")),
        DropdownMenuItem(value: "Sedang", child: Text("Sedang")),
        DropdownMenuItem(value: "Tinggi", child: Text("Tinggi")),
        DropdownMenuItem(value: "Penting", child: Text("Penting")),
      ],
      onChanged: (v) => setState(() => priority = v!),
    );
  }

  // ============================================================
  // ATTACHMENT (REAL UPLOAD)
  // ============================================================
  Widget _attachmentUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: attachments
              .map(
                (f) => Chip(
                  label: Text(f.name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => setState(() => attachments.remove(f)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
            );
            if (result != null) {
              setState(() {
                attachments.addAll(result.files);
              });
            }
          },
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload Lampiran"),
        ),
      ],
    );
  }

  // ============================================================
  // SCHEDULE
  // ============================================================
  Widget _scheduleSelector() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Jadwalkan Publikasi"),
          value: schedule,
          onChanged: (v) => setState(() => schedule = v),
        ),
        if (schedule)
          TextField(
            controller: scheduledDateCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Pilih tanggal publikasi",
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                initialDate: DateTime.now(),
              );
              if (picked != null) {
                scheduledDateCtrl.text = picked.toString().split(" ").first;
              }
            },
          ),
      ],
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================
  Widget _buttons(bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {},
            child: Text(isEdit ? "Simpan Perubahan" : "Publikasikan"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ),
      ],
    );
  }
}
