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
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(data["foto"] ?? ""),
            ),
            const SizedBox(width: 16),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["nama"] ?? "-", style: _headerName),
                  Text("NIP: ${data["nip"] ?? "-"}", style: _headerSub),
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

      // ⭐ Label tidak bold lagi
      const Text(
        "Kelas Diampu:",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textDark,
        ),
      ),

      const SizedBox(height: 10), // ⭐ Tambah spacing lebih besar

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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            alignment: Alignment.centerLeft,
          ),
          child: const Text(
            "Ubah Kata Sandi",
            style: TextStyle(
              color: AppColors.primary,
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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

  // =============== TEMPLATE CARD ===============
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

  // TEXT STYLE
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
