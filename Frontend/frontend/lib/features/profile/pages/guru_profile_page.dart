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
          _profileHeader(context),
          const SizedBox(height: 20),
          _personalInformationCard(),
          const SizedBox(height: 20),
          _academicInformationCard(),
          const SizedBox(height: 20),
          _accountSettings(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER PROFIL
  // ============================================================
  Widget _profileHeader(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // BLUE HEADER
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
                const SizedBox(width: 16),
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
                        "Guru ${data["mapel"] ?? "-"}",
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
  // CARD INFORMASI PRIBADI
  // ============================================================
  Widget _personalInformationCard() {
    return _infoCard(
      title: "Informasi Pribadi",
      children: [
        _row("Nama Lengkap", data["nama"]),
        _row("NIP", data["nip"]),
        _row("Email", data["email"]),
        _row("No HP", data["hp"]),
        _row("Jenis Kelamin", data["gender"]),
        _row("Alamat", data["alamat"]),
      ],
    );
  }

  // ============================================================
  // CARD INFORMASI AKADEMIK (Guru)
  // ============================================================
  Widget _academicInformationCard() {
    List kelas = data["kelas"] ?? [];

    return _infoCard(
      title: "Informasi Akademik",
      children: [
        _row("Mata Pelajaran", data["mapel"]),
        Row(
          children: [
            const Text(
              "Kelas yang Diampu:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
        _row("Total RPP Dibuat", data["rpp"].toString()),
        _row("Total Jam Mengajar", data["jam"].toString()),
      ],
    );
  }

  // ============================================================
  // CARD PENGATURAN AKUN
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
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // UTIL CARD TEMPLATE
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
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
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
          SizedBox(width: 180, child: Text("$label")),
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
