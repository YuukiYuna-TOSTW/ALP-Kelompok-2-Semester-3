import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/profile_layout.dart';

class AdminProfilePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdminProfilePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      role: "admin",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 20),
          _personalInfo(),
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
                      const SizedBox(height: 4),
                      const Text(
                        "Admin",
                        style: TextStyle(color: Colors.white70),
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
  // INFORMASI PRIBADI
  // ============================================================
  Widget _personalInfo() {
    return _infoCard(
      title: "Informasi Pribadi",
      children: [
        _row("Nama", data["nama"]),
        _row("Email", data["email"]),
        _row("No HP", data["hp"]),
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
