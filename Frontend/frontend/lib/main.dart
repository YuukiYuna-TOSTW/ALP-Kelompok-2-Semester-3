import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';

//
// =======================================================
// 🟣 ROLE CONTROLLER (Testing role saat belum ada login backend)
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
// 🎨 ROOT APP — Tema + Routing
// =======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SMPN 1 Bontonompo Selatan",
      theme: AppTheme.lightTheme,

      // halaman pertama
      initialRoute: "/role-preview",

      // semua routes dipusatkan di app_routes.dart
      routes: AppRoutes.allRoutes(context),
    );
  }
}
