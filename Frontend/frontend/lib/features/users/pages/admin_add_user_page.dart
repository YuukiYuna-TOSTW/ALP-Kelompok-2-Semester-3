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

  final nameCtrl = TextEditingController();
  final nipCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    nipCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // ================= HEADER =================
                  _cardHeader(context),

                  // ================= SCROLLABLE CONTENT =================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================= INFORMASI PRIBADI =================
                          UserFormSection(
                            title: "Informasi Pribadi",
                            children: [
                              TextField(
                                controller: nameCtrl,
                                decoration: _input("Nama Lengkap"),
                              ),
                              TextField(
                                controller: nipCtrl,
                                decoration: _input("NIP"),
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                controller: emailCtrl,
                                decoration: _input("Email"),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextField(
                                controller: phoneCtrl,
                                decoration: _input("No. HP"),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),

                          // ================= ROLE PENGGUNA =================
                          UserFormSection(
                            title: "Role Pengguna",
                            children: [
                              DropdownButtonFormField<String>(
                                value: role,
                                decoration: _input("Role"),
                                items:
                                    const ["Guru", "Kepsek", "Wakasek", "Admin"]
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (v) => setState(() => role = v!),
                              ),
                              RoleDynamicFields(role: role),
                            ],
                          ),

                          // ================= DATA LOGIN =================
                          UserFormSection(
                            title: "Data Login",
                            children: [
                              TextField(
                                enabled: false,
                                decoration: _input("Username (Otomatis)"),
                              ),
                              TextField(
                                controller: passwordCtrl,
                                decoration: _input("Password Awal"),
                                obscureText: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ================= ACTION BUTTON =================
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: simpan user baru
                                  },
                                  child: const Text(
                                    "Simpan Pengguna",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Batal"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER CARD =================
  Widget _cardHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.8)],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 6),
          const Text(
            "Tambah Pengguna",
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
}
