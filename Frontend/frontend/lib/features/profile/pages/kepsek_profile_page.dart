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
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER PROFIL
  // ============================================================
  Widget _header(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            width: double.infinity,
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
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(data["foto"] ?? ""),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["nama"] ?? "-",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "NIP: ${data["nip"] ?? "-"}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        data["jabatan"] ?? "Kepala Sekolah",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Menjabat sejak ${data["tahun_menjabat"] ?? "-"}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/profile/edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Edit Profil",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMASI JABATAN
  // ============================================================
  Widget _infoJabatan() {
    return _infoCard(
      title: "Informasi Jabatan",
      children: [
        _row("Jabatan", data["jabatan"]),
        _row("Tahun Menjabat", data["tahun_menjabat"]),
      ],
    );
  }

  // ============================================================
  // INFORMASI PRIBADI
  // ============================================================
  Widget _infoPribadi() {
    return _infoCard(
      title: "Informasi Pribadi",
      children: [
        _row("Nama", data["nama"]),
        _row("NIP", data["nip"]),
        _row("Email", data["email"]),
        _row("No HP", data["hp"]),
        _row("Alamat", data["alamat"]),
      ],
    );
  }

  // ============================================================
  // PENGATURAN AKUN
  // ============================================================
  Widget _accountSettings(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/profile/password"),
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
          ],
        ),
      ),
    );
  }

  // ============================================================
  // UTIL TEMPLATE
  // ============================================================
  Widget _infoCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
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
}
