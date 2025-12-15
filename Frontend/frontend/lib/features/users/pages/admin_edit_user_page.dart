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

  late TextEditingController nameCtrl;
  late TextEditingController nipCtrl;
  late TextEditingController emailCtrl;

  @override
  void initState() {
    super.initState();
    role = widget.data["role"] ?? "Guru";
    active = widget.data["active"] ?? true;

    nameCtrl = TextEditingController(text: widget.data["nama"] ?? "");
    nipCtrl = TextEditingController(text: widget.data["nip"] ?? "");
    emailCtrl = TextEditingController(text: widget.data["email"] ?? "");
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    nipCtrl.dispose();
    emailCtrl.dispose();
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
                          // ================= DATA PENGGUNA =================
                          UserFormSection(
                            title: "Data Pengguna",
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
                            ],
                          ),

                          // ================= ROLE & STATUS =================
                          UserFormSection(
                            title: "Role & Status",
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

                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Akun Aktif"),
                                value: active,
                                onChanged: (v) => setState(() => active = v),
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
                                    // TODO: simpan perubahan
                                  },
                                  child: const Text(
                                    "Simpan Perubahan",
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
            "Edit Data Pengguna",
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
