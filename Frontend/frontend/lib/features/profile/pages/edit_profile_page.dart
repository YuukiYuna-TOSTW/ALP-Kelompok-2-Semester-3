import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/theme/colors.dart';

class EditProfilePage extends StatefulWidget {
  final String role;
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
  File? pickedImage; // foto asli dari file picker

  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 760,
          ), // tidak terlalu besar
          child: Card(
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 5,
            shadowColor: Colors.black12,

            child: Column(
              children: [
                _header(context),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 26,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _photoPicker(),
                        const SizedBox(height: 24),

                        _textField("Nama", nameCtrl),
                        _textField("Email", emailCtrl),
                        _textField("No HP", phoneCtrl),
                        _textField("Alamat", addressCtrl),

                        if (widget.role == "kepsek") ...[
                          _disabledField("Jabatan", widget.data["jabatan"]),
                          _textField("Tugas Utama", tugasCtrl),
                          _textField("Tahun Menjabat", tahunCtrl),
                        ],

                        if (widget.role == "guru") _genderSelector(),

                        const SizedBox(height: 32),
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
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),

      child: Row(
        children: const [
          Icon(Icons.edit, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Text(
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
  // FOTO PICKER
  // ============================================================
  Widget _photoPicker() {
    return Row(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: pickedImage != null
              ? FileImage(pickedImage!)
              : (foto.isNotEmpty ? NetworkImage(foto) : null) as ImageProvider?,
          child: (pickedImage == null && foto.isEmpty)
              ? const Icon(Icons.person, size: 48)
              : null,
        ),
        const SizedBox(width: 16),

        ElevatedButton.icon(
          onPressed: _pickPhoto,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.upload_rounded),
          label: const Text("Ganti Foto"),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT FIELD
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
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
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          const SizedBox(height: 6),
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
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Simpan"),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Batal"),
          ),
        ),
      ],
    );
  }
}
