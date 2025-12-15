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
  String priority = "Normal";
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
      priority = d["prioritas"] ?? "Normal";

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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Judul Pengumuman"),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukkan judul",
                  ),
                ),

                const SizedBox(height: 22),
                _label("Isi Pengumuman"),
                const SizedBox(height: 6),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Tulis isi pengumuman...",
                  ),
                ),

                const SizedBox(height: 22),
                _label("Tujuan Pengumuman"),
                const SizedBox(height: 6),
                _audienceSelector(),

                const SizedBox(height: 22),
                _label("Prioritas"),
                const SizedBox(height: 6),
                _prioritySelector(),

                const SizedBox(height: 22),
                _label("Lampiran"),
                const SizedBox(height: 6),
                _attachmentUploader(),

                const SizedBox(height: 22),
                _label("Tanggal Publikasi"),
                const SizedBox(height: 6),
                _scheduleSelector(),

                const SizedBox(height: 32),
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

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: AppColors.primary,
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
          title: const Text("Pilih Semua Guru"),
          onChanged: (v) {
            setState(() {
              selectedAudience = v == true ? ["Semua Guru"] : [];
            });
          },
        ),
        ...guruList.map(
          (g) => CheckboxListTile(
            value: selectedAudience.contains(g),
            title: Text(g),
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  selectedAudience.add(g);
                  selectedAudience.remove("Semua Guru");
                } else {
                  selectedAudience.remove(g);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRIORITY (RAPI & JELAS)
  // ============================================================
  Widget _prioritySelector() {
    return Row(
      children: ["Rendah", "Normal", "Tinggi"].map((p) {
        return Expanded(
          child: RadioListTile<String>(
            title: Text(p),
            value: p,
            groupValue: priority,
            onChanged: (v) => setState(() => priority = v!),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ATTACHMENT (REAL FILE)
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
        const SizedBox(height: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text("Tambah Lampiran"),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
            );
            if (result != null) {
              setState(() => attachments.addAll(result.files));
            }
          },
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
              hintText: "Pilih tanggal",
            ),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                initialDate: DateTime.now(),
              );
              if (d != null) {
                scheduledDateCtrl.text = d.toString().split(" ").first;
              }
            },
          ),
      ],
    );
  }

  // ============================================================
  // BUTTONS (SIMPLE & JELAS)
  // ============================================================
  Widget _buttons(bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {},
            child: Text(isEdit ? "Simpan Perubahan" : "Publikasikan"),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ),
      ],
    );
  }
}
