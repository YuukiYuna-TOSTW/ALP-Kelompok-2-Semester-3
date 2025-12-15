import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/profile_layout.dart';

class GuruProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const GuruProfilePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      role: "guru",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 20),
          _infoPribadi(),
          const SizedBox(height: 20),
          _infoAkademik(),
          const SizedBox(height: 20),
          _accountSettings(context),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // FOTO PROFIL
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child:
                    data["foto"] != null && data["foto"].toString().isNotEmpty
                    ? Image.network(
                        data["foto"],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatar(),
                      )
                    : _defaultAvatar(),
              ),
            ),

            // ⭐ JARAK TAMBAHAN ANTARA FOTO & TEKS
            const SizedBox(width: 20),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["nama"] ?? "-", style: _headerName),
                  const SizedBox(height: 4),
                  Text("NIP: ${data["nip"] ?? "-"}", style: _headerSub),
                  const SizedBox(height: 2),
                  Text("Guru ${data["mapel"] ?? "-"}", style: _headerSub),
                ],
              ),
            ),

            // TOMBOL EDIT
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                "/profile/edit",
                arguments: data,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text(
                "Edit Profil",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INFORMASI PRIBADI =================
  Widget _infoPribadi() {
    return _cardSection("Informasi Pribadi", [
      _row("Nama", data["nama"]),
      _row("NIP", data["nip"]),
      _row("Email", data["email"]),
      _row("No HP", data["hp"]),
      _row("Jenis Kelamin", data["gender"]),
      _row("Alamat", data["alamat"]),
    ]);
  }

  // ================= INFORMASI AKADEMIK =================
  Widget _infoAkademik() {
    List kelas = data["kelas"] ?? [];

    return _cardSection("Informasi Akademik", [
      _row("Mata Pelajaran", data["mapel"]),
      const SizedBox(height: 10),

      const Text(
        "Kelas Diampu:",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textDark,
        ),
      ),
      const SizedBox(height: 10),

      Wrap(
        spacing: 8,
        children: kelas
            .map(
              (e) => Chip(
                label: Text(e.toString()),
                backgroundColor: AppColors.primary.withOpacity(.15),
              ),
            )
            .toList(),
      ),

      const SizedBox(height: 10),
      _row("Total RPP Dibuat", data["rpp"]),
      _row("Total Jam Mengajar", data["jam"]),
    ]);
  }

  // ================= ACCOUNT SETTINGS =================
  Widget _accountSettings(BuildContext context) {
    return _cardSection("Pengaturan Akun", [
      Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, "/profile/password"),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
          ),
          child: const Text(
            "Ubah Kata Sandi",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const SizedBox(height: 4),
      Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
          ),
          child: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }

  // ================= TEMPLATE CARD =================
  Widget _cardSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _sectionTitle),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.primary.withOpacity(.1),
      child: const Icon(Icons.person, size: 40, color: AppColors.primary),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label)),
          Expanded(
            child: Text(
              value?.toString() ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TEXT STYLES =================
  TextStyle get _headerName => const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle get _headerSub =>
      const TextStyle(color: Colors.white70, fontSize: 13);

  TextStyle get _sectionTitle => const TextStyle(
    color: AppColors.primary,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
}
