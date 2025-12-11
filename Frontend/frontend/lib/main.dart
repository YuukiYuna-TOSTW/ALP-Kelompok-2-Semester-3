import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';
import 'features/dashboard/dashboard_page.dart';

//
// =======================================================
// 🟣 ROLE CONTROLLER (Untuk testing role tanpa login)
// =======================================================
class RoleController extends ChangeNotifier {
  String role = "admin"; // default role

  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }
}

//
// =======================================================
// 🚀 MAIN ENTRY POINT
// =======================================================
void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RoleController())],
      child: const MyApp(),
    ),
  );
}

//
// =======================================================
// 🏫 ROOT APP (Tema + Routing Utama)
// =======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SMPN 1 Bontonompo Selatan",

      // hanya light mode kecil
      theme: AppTheme.lightTheme,

      home: const RolePreviewPage(),
    );
  }
}

//
// =======================================================
// 🔥 ROLE PREVIEW PAGE (Testing dashboard tanpa login)
// =======================================================
class RolePreviewPage extends StatelessWidget {
  const RolePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roleCtrl = context.watch<RoleController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Role Preview • SMPN 1 Bontonompo Selatan",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pilih Role Dashboard",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: roleCtrl.role,
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                  DropdownMenuItem(value: "guru", child: Text("Guru")),
                  DropdownMenuItem(
                    value: "kepsek",
                    child: Text("Kepsek / Wakasek"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<RoleController>().setRole(value);
                  }
                },
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashboardPage(role: roleCtrl.role),
                      ),
                    );
                  },
                  child: const Text("Tampilkan Dashboard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
