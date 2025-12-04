import 'package:flutter/material.dart';

import 'config/theme/app_theme.dart';
import 'features/layout/layout_template.dart';
import 'features/dashboard/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMPN 1 Bontonompo Selatan',

      // pakai tema yang sudah kamu buat
      theme: AppTheme.lightTheme,

      // untuk sekarang: langsung preview dashboard admin
      home: const RootPreview(),
    );
  }
}

/// Halaman root sementara untuk preview UI
class RootPreview extends StatelessWidget {
  const RootPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutTemplate(
      userName: 'Admin SMPN 1 Bontonompo Selatan',
      role: 'admin',
      child: DashboardPage(role: 'admin'),
    );
  }
}
