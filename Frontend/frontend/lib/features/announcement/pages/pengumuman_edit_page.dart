import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class PengumumanFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const PengumumanFormPage({super.key, this.data});

  @override
  State<PengumumanFormPage> createState() => _PengumumanFormPageState();
}

class _PengumumanFormPageState extends State<PengumumanFormPage> {
  final _formKey = GlobalKey<FormState>();

  // ===========================
  // FORM CONTROLLERS
  // ===========================
  final TextEditingController judulC = TextEditingController();
  final TextEditingController isiC = TextEditingController();

  String prioritas = "Normal";
  bool publishNow = true;
  DateTime? publishDate;

  List<String> targetGuru = [];
  List<String> targetWali = [];

  bool hasAttachment = false;

  // Contoh list guru & wali kelas
  final List<String> guruList = ["Bu Sinta", "Pak Amir", "Bu Ayu"];
  final List<String> waliKelasList = ["7A", "7B", "8A", "9A"];

  @override
  void initState() {
    super.initState();

    // jika EDIT mode → isi data default
    if (widget.data != null) {
      final d = widget.data!;
      judulC.text = d["judul"] ?? "";
      isiC.text = d["isi"] ?? "";
      prioritas = d["prioritas"] ?? "Normal";
      hasAttachment = d["lampiran"] ?? false;
    }
  }

  // ===========================
  // SELECT DATE
  // ===========================
  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );

    if (picked != null) {
      setState(() => publishDate = picked);
    }
  }

  // ===========================
  // MAIN UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.data != null;

    return RppLayout(
      selectedRoute: "/announcement",
      role: "admin",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _header(isEdit),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textField("Judul Pengumuman", judulC),
                          const SizedBox(height: 20),
                          _textareaField("Isi Pengumuman", isiC),
                          const SizedBox(height: 20),
                          _selectTargetAudience(),
                          const SizedBox(height: 20),
                          _selectPrioritas(),
                          const SizedBox(height: 20),
                          _lampiranPicker(),
                          const SizedBox(height: 20),
                          _jadwalPublikasi(),
                          const SizedBox(height: 30),
                          _actionButtons(isEdit),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================
  // HEADER
  // ===========================
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            isEdit ? "Edit Pengumuman" : "Buat Pengumuman",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  // TEXT FIELD
  // ===========================
  Widget _textField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  // ===========================
  // TEXTAREA
  // ===========================
  Widget _textareaField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: 6,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  // ===========================
  // TARGET AUDIENCE
  // ===========================
  Widget _selectTargetAudience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tujuan Pengumuman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _multiselect("Guru Mapel", guruList, targetGuru),
        const SizedBox(height: 10),

        _multiselect("Wali Kelas", waliKelasList, targetWali),
      ],
    );
  }

  Widget _multiselect(
    String label,
    List<String> sourceList,
    List<String> selectedList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Wrap(
          spacing: 10,
          children: sourceList.map((item) {
            final isSelected = selectedList.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    selectedList.add(item);
                  } else {
                    selectedList.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================
  // PRIORITAS
  // ===========================
  Widget _selectPrioritas() {
    return DropdownButtonFormField<String>(
      value: prioritas,
      items: [
        "Rendah",
        "Normal",
        "Tinggi",
        "Penting",
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      decoration: const InputDecoration(labelText: "Prioritas"),
      onChanged: (v) => setState(() => prioritas = v!),
    );
  }

  // ===========================
  // LAMPIRAN
  // ===========================
  Widget _lampiranPicker() {
    return Row(
      children: [
        Checkbox(
          value: hasAttachment,
          onChanged: (v) => setState(() => hasAttachment = v!),
        ),
        const Text("Tambahkan Lampiran (PDF/JPG/DOCX)"),
      ],
    );
  }

  // ===========================
  // JADWAL PUBLIKASI
  // ===========================
  Widget _jadwalPublikasi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Waktu Publikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        RadioListTile(
          value: true,
          groupValue: publishNow,
          title: const Text("Publikasikan sekarang"),
          onChanged: (v) => setState(() => publishNow = true),
        ),
        RadioListTile(
          value: false,
          groupValue: publishNow,
          title: const Text("Jadwalkan publikasi"),
          onChanged: (v) => setState(() => publishNow = false),
        ),
        if (!publishNow)
          ElevatedButton(
            onPressed: pickDate,
            child: Text(
              publishDate == null
                  ? "Pilih Tanggal"
                  : publishDate.toString().split(" ")[0],
            ),
          ),
      ],
    );
  }

  // ===========================
  // ACTION BUTTONS
  // ===========================
  Widget _actionButtons(bool isEdit) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEdit
                        ? "Pengumuman diperbarui!"
                        : "Pengumuman diterbitkan!",
                  ),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(isEdit ? "Update & Terbitkan" : "Publikasikan"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Disimpan ke Draft")),
              );
              Navigator.pop(context);
            },
            child: const Text("Simpan Draft"),
          ),
        ),
      ],
    );
  }
}
