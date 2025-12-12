import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';

// DASHBOARD
import 'features/dashboard/dashboard_page.dart';

// RPP PAGES
import 'features/rpp/pages/rpp_list_pages.dart';
import 'features/rpp/pages/rpp_form_page.dart';
import 'features/rpp/pages/rpp_edit_page.dart';
import 'features/rpp/pages/rpp_preview_page.dart';
import 'features/rpp/pages/rpp_history_page.dart';

//
// =======================================================
// 🟣 ROLE CONTROLLER (Untuk testing role tanpa login)
// =======================================================
class RoleController extends ChangeNotifier {
  String role = "admin";

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
// 🏫 ROOT APP (Routing Utama + Tema)
// =======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SMPN 1 Bontonompo Selatan",
      theme: AppTheme.lightTheme,

      initialRoute: "/role-preview",

      routes: {
        "/role-preview": (_) => const RolePreviewPage(),

        "/dashboard": (context) {
          final role = context.read<RoleController>().role;
          return DashboardPage(role: role);
        },

        // =====================================================
        // 🟦 RPP ROUTES — FINAL VERSION
        // =====================================================
        "/rpp": (_) => const RppListPage(),

        "/rpp/create": (_) => const RppFormPage(),

        "/rpp/edit": (context) {
          final args = ModalRoute.of(context)!.settings.arguments;

          // Jika args berupa Map (data lengkap)
          if (args is Map<String, dynamic>) {
            return RppEditPage(data: args);
          }

          // Jika args berupa format lama
          if (args is Map) {
            return RppEditPage(
              data: {
                "status": args["status"],
                "revisi": args["revisionNotes"] ?? [],
              },
            );
          }

          return const RppEditPage();
        },

        "/rpp/preview": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          return RppPreviewPage(
            mapel: args?["mapel"] ?? "",
            kelas: args?["kelas"] ?? "",
            bab: args?["bab"] ?? "",
            status: args?["status"] ?? "",
          );
        },

        "/rpp/history": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          return RppHistoryPage(data: args);
        },
      },
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
                    roleCtrl.setRole(value);
                  }
                },
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/dashboard");
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
