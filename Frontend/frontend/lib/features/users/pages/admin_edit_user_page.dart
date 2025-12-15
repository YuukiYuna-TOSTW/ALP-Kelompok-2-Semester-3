import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../widgets/user_form_section.dart';
import '../widgets/role_dynamic_fields.dart';

class AdminEditUserPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const AdminEditUserPage({super.key, required this.data});

  @override
  State<AdminEditUserPage> createState() => _AdminEditUserPageState();
}

class _AdminEditUserPageState extends State<AdminEditUserPage> {
  late String role;
  late bool active;

  @override
  void initState() {
    super.initState();
    role = widget.data["role"] ?? "Guru";
    active = widget.data["active"] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Edit Pengguna")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ================= DATA PENGGUNA =================
            UserFormSection(
              title: "Data Pengguna",
              children: [
                TextField(
                  controller: TextEditingController(text: widget.data["nama"]),
                  decoration: const InputDecoration(labelText: "Nama Lengkap"),
                ),
                TextField(
                  controller: TextEditingController(text: widget.data["nip"]),
                  decoration: const InputDecoration(labelText: "NIP"),
                ),
                TextField(
                  controller: TextEditingController(text: widget.data["email"]),
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ],
            ),

            // ================= ROLE & STATUS =================
            UserFormSection(
              title: "Role & Status",
              children: [
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: "Role"),
                  items: const ["Guru", "Kepsek", "Wakasek", "Admin"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => role = v!),
                ),

                RoleDynamicFields(role: role),

                SwitchListTile(
                  title: const Text("Akun Aktif"),
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                ),
              ],
            ),

            // ================= RESET PASSWORD =================
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock_reset),
                label: const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
