import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';

// =======================================================
// 🟣 ROLE CONTROLLER
// =======================================================
class RoleController extends ChangeNotifier {
  String role = "admin";

  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RoleController())],
      child: const MyApp(),
    ),
  );
}

// =======================================================
// ROOT APP
// =======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SMPN 1 Bontonompo Selatan",
      theme: AppTheme.lightTheme,

      // Tetap gunakan role-preview sebagai awal
      initialRoute: "/role-preview",

      // Semua route berasal dari AppRoutes
      routes: AppRoutes.allRoutes(context),
    );
  }
}
