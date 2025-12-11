import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final first = prefs.getBool('first_login') ?? true;

    if (emailC.text != email || passC.text != password) {
      snack("Email atau password salah");
      return;
    }

    if (first) {
      showChangePassword(context);
    } else {
      // TODO: Teman akan hubungkan ke halaman selanjutnya
      snack("Login berhasil");
    }
  }

  void snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

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
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Login"),
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
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final codeC = TextEditingController();

  Future<void> register() async {
    if (emailC.text.isEmpty ||
        passC.text.isEmpty ||
        codeC.text.isEmpty) {
      popup("Gagal", "Semua field wajib diisi");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailC.text);
    await prefs.setString('password', passC.text);
    await prefs.setString('kode_akses', codeC.text);
    await prefs.setBool('first_login', true);

    popup("Berhasil",
        "Akun berhasil dibuat\nPassword bersifat sementara",
        success: true);
  }

  void popup(String title, String msg, {bool success = false}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(blurRadius: 35, color: Colors.black26)
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  size: 64,
                  color: success ? secondary : Colors.redAccent,
                ),
                const SizedBox(height: 18),
                Text(title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (success) widget.onFlip();
                    },
                    child: const Text("OK"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) =>
          Transform.scale(scale: anim.value, child: child),
    );
  }

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
                    controller: emailC,
                    decoration: const InputDecoration(labelText: "Email")),
                const SizedBox(height: 16),
                TextField(
                    controller: passC,
                    decoration: const InputDecoration(labelText: "Password Awal")),
                const SizedBox(height: 16),
                TextField(
                    controller: codeC,
                    decoration: const InputDecoration(labelText: "Kode Akses")),
                const SizedBox(height: 34),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Buat Akun"),
                  ),
                ),
                const SizedBox(height: 20),
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
  final saved = prefs.getString('password');
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

              await prefs.setString('password', newC.text);
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
