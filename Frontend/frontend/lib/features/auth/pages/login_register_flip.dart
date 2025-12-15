import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/login_register_service.dart'; // ✅ import service

const Color primary = Color(0xFF75CFFF);
const Color secondary = Color(0xFF4DAFF5);
const Color background = Color(0xFFFBFBFB);

// =======================================================
// ===============  MAIN LOGIN + REGISTER  ===============
// =======================================================

class LoginRegisterFlip extends StatefulWidget {
  const LoginRegisterFlip({super.key});

  @override
  State<LoginRegisterFlip> createState() => _LoginRegisterFlipState();
}

class _LoginRegisterFlipState extends State<LoginRegisterFlip>
    with SingleTickerProviderStateMixin {
  bool showBack = false;
  late AnimationController ctrl;
  late Animation<double> anim;

  @override
  void initState() {
    super.initState();

    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    anim = CurvedAnimation(
      parent: ctrl,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  void flip() {
    setState(() => showBack = !showBack);
    showBack ? ctrl.forward() : ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: AnimatedBuilder(
          animation: anim,
          builder: (_, __) {
            final angle = anim.value * 3.14;
            final isBack = anim.value >= .5;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)        // ✨ smooth perspective
                ..rotateY(angle),
              child: Container(
                width: 900,
                height: 520,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 40,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: isBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0015)
                          ..rotateY(3.14),
                        child: RegisterCard(onFlip: flip),
                      )
                    : LoginCard(onFlip: flip),
              ),
            );
          },
        ),
      ),
    );
  }
}

// =======================================================
// ======================= LOGIN =========================
// =======================================================

class LoginCard extends StatefulWidget {
  final VoidCallback onFlip;
  const LoginCard({super.key, required this.onFlip});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool hide = true;
  bool isLoading = false;

  Future<void> login() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      snack("Email dan password tidak boleh kosong");
      return;
    }

    setState(() => isLoading = true);
    try {
      final result = await LoginRegisterService.login(
        email: emailC.text,
        password: passC.text,
      );

      if (result['success'] == true) {
        snack("Login berhasil");
      } else {
        final raw = (result['message'] ?? '').toString();
        final msg = raw.toLowerCase();
        if (msg.contains("invalid") || msg.contains("salah") || msg.contains("unauthorized")) {
          snack("Email atau password salah");
        } else if (msg.contains("timeout") || msg.contains("koneksi") || msg.contains("failed host")) {
          snack("Gagal terhubung ke server");
        } else if (msg.contains("server") || msg.contains("internal") || msg.contains("bad gateway") || msg.contains("unavailable")) {
          snack("Terjadi kesalahan pada server, coba lagi nanti");
        } else {
          snack("Login gagal: ${raw.isEmpty ? 'Terjadi kesalahan' : raw}");
        }
      }
    } catch (_) {
      snack("Terjadi kesalahan koneksi");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // LEFT
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Login",
                    style:
                        TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                const SizedBox(height: 28),
                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: "Email"),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: passC,
                  obscureText: hide,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                          hide ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => hide = !hide),
                    ),
                  ),
                  enabled: !isLoading,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Login"),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onFlip,
                  child: const Text(
                    "Admin? Register akun",
                    style: TextStyle(
                        color: secondary, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),

        // RIGHT IMAGE
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(24)),
              gradient: LinearGradient(colors: [primary, secondary]),
            ),
            child: const Center(
              child: Icon(Icons.lock_outline,
                  color: Colors.white, size: 150),
            ),
          ),
        ),
      ],
    );
  }
}

// =======================================================
// ===================== REGISTER ========================
// =======================================================

class RegisterCard extends StatefulWidget {
  final VoidCallback onFlip;
  const RegisterCard({super.key, required this.onFlip});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final codeC = TextEditingController();
  bool isLoading = false;

  // ✅ opsi role
  final roles = const [
    ("Guru", "Guru"),
    ("Kepala Sekolah", "Kepala_Sekolah"),
    ("Admin", "Admin"),
  ];
  String? selectedRole;

  Future<void> register() async {
    if (namaC.text.isEmpty ||
        emailC.text.isEmpty ||
        passC.text.isEmpty ||
        selectedRole == null) {
      snack("Semua field wajib diisi");
      return;
    }

    codeC.text = selectedRole!;
    setState(() => isLoading = true);
    try {
      final result = await LoginRegisterService.register(
        namaUser: namaC.text,
        email: emailC.text,
        password: passC.text,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('Role', selectedRole!);

      if (result['success'] == true) {
        snack("Akun berhasil dibuat");
        widget.onFlip();
      } else {
        final raw = (result['message'] ?? '').toString();
        final msg = raw.toLowerCase();

        if (msg.contains("Email".toLowerCase()) && msg.contains("sudah")) {
          snack("Email sudah digunakan");
        } else if ((msg.contains("Nama_User".toLowerCase()) || msg.contains("nama")) && msg.contains("sudah")) {
          snack("Nama lengkap sudah digunakan");
        } else if (msg.contains("Email".toLowerCase()) && (msg.contains("invalid") || msg.contains("format"))) {
          snack("Email tidak valid");
        } else if (msg.contains("Password".toLowerCase()) && (msg.contains("minimal") || msg.contains("min"))) {
          snack("Password minimal 6 karakter");
        } else if (msg.contains("timeout") || msg.contains("koneksi") || msg.contains("failed host")) {
          snack("Gagal terhubung ke server");
        } else if (msg.contains("server") || msg.contains("internal") || msg.contains("bad gateway") || msg.contains("unavailable")) {
          snack("Terjadi kesalahan pada server, coba lagi nanti");
        } else {
          snack("Akun gagal dibuat: ${raw.isEmpty ? 'Terjadi kesalahan' : raw}");
        }
      }
    } catch (_) {
      snack("Terjadi kesalahan koneksi");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // IMAGE LEFT
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(24)),
              gradient: LinearGradient(colors: [secondary, primary]),
            ),
            child: const Center(
              child: Icon(Icons.admin_panel_settings,
                  color: Colors.white, size: 140),
            ),
          ),
        ),

        // FORM
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Admin Register",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextField(
                    controller: namaC,
                    decoration: const InputDecoration(labelText: "Nama Lengkap"),
                    enabled: !isLoading),
                const SizedBox(height: 16),
                TextField(
                    controller: emailC,
                    decoration: const InputDecoration(labelText: "Email"),
                    enabled: !isLoading),
                const SizedBox(height: 16),
                TextField(
                    controller: passC,
                    decoration: const InputDecoration(labelText: "Password Awal"),
                    enabled: !isLoading),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: "Role"),
                  items: roles
                      .map((r) => DropdownMenuItem(
                            value: r.$2,
                            child: Text(r.$1),
                          ))
                      .toList(),
                  onChanged: isLoading
                      ? null
                      : (val) {
                          setState(() {
                            selectedRole = val;
                            codeC.text = val ?? '';
                          });
                        },
                ),
                const SizedBox(height: 34),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Buat Akun"),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: widget.onFlip,
                  child: const Text(
                    "Sudah punya akun? Login",
                    style: TextStyle(
                        color: secondary, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =======================================================
// ================== CHANGE PASSWORD POPUP ==============
// =======================================================

Future<void> showChangePassword(BuildContext context) async {
  final oldC = TextEditingController();
  final newC = TextEditingController();
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('Password');
  bool h1 = true, h2 = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (context, set) => AlertDialog(
        title: const Text("Ganti Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldC,
              obscureText: h1,
              decoration: InputDecoration(
                labelText: "Password Lama",
                suffixIcon: IconButton(
                  icon: Icon(
                      h1 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => set(() => h1 = !h1),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: newC,
              obscureText: h2,
              decoration: InputDecoration(
                labelText: "Password Baru",
                suffixIcon: IconButton(
                  icon:
                      Icon(h2 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => set(() => h2 = !h2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (oldC.text != saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password lama salah")));
                return;
              }

              await prefs.setString('Password', newC.text);
              await prefs.setBool('first_login', false);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password berhasil diubah")),
              );
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    ),
  );
}
