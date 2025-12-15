import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../widgets/user_form_section.dart';
import '../widgets/role_dynamic_fields.dart';

class AdminAddUserPage extends StatefulWidget {
  const AdminAddUserPage({super.key});

  @override
  State<AdminAddUserPage> createState() => _AdminAddUserPageState();
}

class _AdminAddUserPageState extends State<AdminAddUserPage> {
  String role = "Guru";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Tambah Pengguna")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            UserFormSection(
              title: "Informasi Pribadi",
              children: const [
                TextField(decoration: InputDecoration(labelText: "Nama")),
                TextField(decoration: InputDecoration(labelText: "NIP")),
                TextField(decoration: InputDecoration(labelText: "Email")),
                TextField(decoration: InputDecoration(labelText: "No HP")),
              ],
            ),

            UserFormSection(
              title: "Role Pengguna",
              children: [
                DropdownButtonFormField(
                  value: role,
                  items: ["Guru", "Kepsek", "Wakasek", "Admin"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => role = v!),
                  decoration: const InputDecoration(labelText: "Role"),
                ),
                RoleDynamicFields(role: role),
              ],
            ),

            UserFormSection(
              title: "Login Data",
              children: const [
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: "Username (Auto)"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Password Awal"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Simpan")),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
