import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class PengumumanFormPage extends StatefulWidget {
  final Map<String, dynamic>? data; // <-- menerima data untuk edit

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
  List<String> attachments = [];

  final List<String> guruList = ["Bu Sinta", "Pak Amir", "Bu Ayu", "Bu Lina"];

  @override
  void initState() {
    super.initState();

    // ===============================
    // PREFILL DATA SAAT MODE EDIT
    // ===============================
    if (widget.data != null) {
      final d = widget.data!;

      titleCtrl.text = d["judul"] ?? "";
      bodyCtrl.text = d["isi"] ?? "";

      // Audience
      if (d["target"] is List) {
        selectedAudience = List<String>.from(d["target"]);
      }

      // Prioritas
      priority = d["prioritas"] ?? "Normal";

      // Lampiran
      if (d["lampiran"] is List) {
        attachments = List<String>.from(d["lampiran"]);
      }

      // Jadwal Publikasi
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
  // CARD UTAMA
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
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukkan judul",
                  ),
                ),

                const SizedBox(height: 20),
                _label("Isi Pengumuman"),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Tulis isi pengumuman...",
                  ),
                ),

                const SizedBox(height: 20),
                _label("Tujuan Pengumuman"),
                _audienceSelector(),

                const SizedBox(height: 20),
                _label("Prioritas"),
                _prioritySelector(),

                const SizedBox(height: 20),
                _label("Lampiran"),
                _attachmentUploader(),

                const SizedBox(height: 20),
                _label("Tanggal Publikasi"),
                _scheduleSelector(),

                const SizedBox(height: 30),
                _buttons(isEdit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER CARD
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
  // LABEL
  // ============================================================
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
  // AUDIENCE CHECKBOX
  // ============================================================
  Widget _audienceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: selectedAudience.contains("Semua Guru"),
          onChanged: (v) {
            setState(() {
              if (v == true) {
                selectedAudience = ["Semua Guru"];
              } else {
                selectedAudience.remove("Semua Guru");
              }
            });
          },
          title: const Text("Pilih Semua Guru"),
        ),

        ...guruList.map(
          (g) => CheckboxListTile(
            value: selectedAudience.contains(g),
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
            title: Text(g),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRIORITY SELECTOR
  // ============================================================
  Widget _prioritySelector() {
    return DropdownButtonFormField<String>(
      value: priority,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      items: [
        "Rendah",
        "Normal",
        "Tinggi",
        "Penting",
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => setState(() => priority = v!),
    );
  }

  // ============================================================
  // ATTACHMENT UPLOAD (Dummy)
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
                  label: Text(f),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => setState(() => attachments.remove(f)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),

        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              attachments.add("file_${attachments.length + 1}.pdf");
            });
          },
          icon: const Icon(Icons.upload),
          label: const Text("Upload Lampiran"),
        ),
      ],
    );
  }

  // ============================================================
  // SCHEDULE SELECTOR
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
              final selected = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                initialDate: DateTime.now(),
              );
              if (selected != null) {
                scheduledDateCtrl.text = selected.toString().split(" ").first;
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
        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text("Simpan Draft"),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ),
      ],
    );
  }
}
