import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/profile_layout.dart';

class KepsekProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const KepsekProfilePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      role: "kepsek",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 20),
          _infoJabatan(),
          const SizedBox(height: 20),
          _infoPribadi(),
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
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["nama"] ?? "-", style: _headerName),
                  Text("NIP: ${data["nip"] ?? "-"}", style: _headerSub),
                  Text(data["jabatan"] ?? "Kepala Sekolah", style: _headerSub),
                  Text(
                    "Menjabat sejak ${data["tahun_menjabat"] ?? "-"}",
                    style: _headerSub,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/profile/edit"),
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

  // ================= SECTION: JABATAN =================
  Widget _infoJabatan() {
    return _cardSection("Informasi Jabatan", [
      _row("Jabatan", data["jabatan"]),
      _row("Tahun Menjabat", data["tahun_menjabat"]),
    ]);
  }

  // ================= SECTION: PRIBADI =================
  Widget _infoPribadi() {
    return _cardSection("Informasi Pribadi", [
      _row("Nama", data["nama"]),
      _row("NIP", data["nip"]),
      _row("Email", data["email"]),
      _row("No HP", data["hp"]),
      _row("Alamat", data["alamat"]),
    ]);
  }

  // ================= SECTION: ACCOUNT =================
  Widget _accountSettings(BuildContext context) {
    return _cardSection("Pengaturan Akun", [
      ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, "/profile/password"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text("Ubah Kata Sandi"),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: () {},
        child: const Text(
          "Logout",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    ]);
  }

  // ================= TEMPLATE =================
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

  // TEXT STYLES
  TextStyle get _headerName => const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle get _headerSub =>
      const TextStyle(color: Colors.white70, fontSize: 13);

  TextStyle get _sectionTitle => const TextStyle(
    fontSize: 17,
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );
}
