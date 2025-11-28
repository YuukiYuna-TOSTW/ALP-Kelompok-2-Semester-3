import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isDarkMode = false;

  // 🎨 Color Palette
  final Color bgColor = const Color(0xFFFBFBFB);
  final Color primaryColor = const Color(0xFF75CFFF);
  final Color textColor = const Color(0xFF2F4156);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ================= LOGO & NAMA SEKOLAH =================
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                "SMPN 1 Bontonompo Selatan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ================= MENU DESKTOP =================
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  children: [
                    _navItem("Beranda"),
                    _navItem("Tentang"),
                    _navItem("Informasi"),
                    _navItem("Kontak"),

                    const SizedBox(width: 20),

                    // 🔘 Dark mode toggle (dummy)
                    IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                    ),

                    const SizedBox(width: 10),

                    // 🔒 Login Button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                );
              } else {
                // ================= MOBILE → DRAWER BUTTON =================
                return IconButton(
                  icon: Icon(Icons.menu, color: textColor),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ITEM MENU DESKTOP
  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {},
          child: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
        ),
      ),
    );
  }
}

// ====================================================================
// ====================   DRAWER MOBILE RESPONSIVE   ==================
// ====================================================================

Drawer buildMobileDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xFF75CFFF)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.school, color: Colors.white, size: 50),
              SizedBox(height: 10),
              Text(
                "SMPN 1 Bontonompo Selatan",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),

        _drawerItem(Icons.home, "Beranda", () {}),
        _drawerItem(Icons.account_circle, "Tentang", () {}),
        _drawerItem(Icons.info, "Informasi", () {}),
        _drawerItem(Icons.call, "Kontak", () {}),

        const Divider(),

        // 🔒 Login
        ListTile(
          leading: const Icon(Icons.login, color: Color(0xFF75CFFF)),
          title: const Text("Login"),
          onTap: () {},
        ),

        // 🌙 Dark mode toggle
        ListTile(
          leading: const Icon(Icons.dark_mode, color: Color(0xFF2F4156)),
          title: const Text("Dark Mode"),
          onTap: () {},
        ),
      ],
    ),
  );
}

Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xFF2F4156)),
    title: Text(title),
    onTap: onTap,
  );
}
