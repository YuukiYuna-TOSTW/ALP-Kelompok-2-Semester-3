import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class EditProfilePage extends StatefulWidget {
  final String role; // "guru", "kepsek", "admin"
  final Map<String, dynamic> data;

  const EditProfilePage({super.key, required this.role, required this.data});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController tugasCtrl;
  late TextEditingController tahunCtrl;

  String gender = "Laki-laki";
  String foto = "";

  @override
  void initState() {
    super.initState();

    foto = widget.data["foto"] ?? "";

    nameCtrl = TextEditingController(text: widget.data["nama"] ?? "");
    emailCtrl = TextEditingController(text: widget.data["email"] ?? "");
    phoneCtrl = TextEditingController(text: widget.data["hp"] ?? "");
    addressCtrl = TextEditingController(text: widget.data["alamat"] ?? "");

    tugasCtrl = TextEditingController(text: widget.data["tugas"] ?? "");
    tahunCtrl = TextEditingController(
      text: widget.data["tahun_menjabat"] ?? "",
    );

    gender = widget.data["gender"] ?? "Laki-laki";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _header(context),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _photoPicker(),
                        const SizedBox(height: 20),

                        if (widget.role == "admin")
                          _textField("Nama", nameCtrl),

                        if (widget.role == "kepsek")
                          _disabledField("Jabatan", widget.data["jabatan"]),

                        if (widget.role == "kepsek")
                          _textField("Tugas Utama", tugasCtrl),

                        if (widget.role == "kepsek")
                          _textField("Tahun Menjabat", tahunCtrl),

                        _textField("Email", emailCtrl),
                        _textField("No HP", phoneCtrl),
                        _textField("Alamat", addressCtrl),

                        if (widget.role == "guru") _genderSelector(),

                        const SizedBox(height: 30),
                        _buttons(context),
                      ],
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

  // ============================================================
  // HEADER
  // ============================================================
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
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
          const SizedBox(width: 10),
          const Text(
            "Edit Profil",
            style: TextStyle(
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
  // FOTO PICKER (dummy)
  // ============================================================
  Widget _photoPicker() {
    return Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: foto.isNotEmpty ? NetworkImage(foto) : null,
          child: foto.isEmpty ? const Icon(Icons.person, size: 45) : null,
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              foto = "https://picsum.photos/200"; // dummy foto baru
            });
          },
          icon: const Icon(Icons.upload),
          label: const Text("Ganti Foto"),
        ),
      ],
    );
  }

  // ============================================================
  // TEXTFIELD
  // ============================================================
  Widget _textField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _disabledField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // ============================================================
  // GENDER SELECTOR
  // ============================================================
  Widget _genderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jenis Kelamin",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Radio(
                value: "Laki-laki",
                groupValue: gender,
                onChanged: (v) => setState(() => gender = v!),
              ),
              const Text("Laki-laki"),
              Radio(
                value: "Perempuan",
                groupValue: gender,
                onChanged: (v) => setState(() => gender = v!),
              ),
              const Text("Perempuan"),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================
  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Simpan Perubahan"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ),
      ],
    );
  }
}
