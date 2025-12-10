import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib: Firebase Core
import 'firebase_options.dart'; // Wajib: File Konfigurasi
import 'features/layout/layout_template.dart';
import 'features/dashboard/pages/dashboard_page.dart'; // FIXED PATH

// Hapus import 'package:firebase_ai/firebase_ai.dart';
// karena tidak digunakan di sini.

void main() async {
  // 1. Wajib: Memastikan Flutter Widgets Binding sudah diinisialisasi
  //    sebelum memanggil fungsi asynchronous (await).
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Wajib: Inisialisasi Firebase Core.
  //    Ini harus diselesaikan sebelum aplikasi berjalan.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Menjalankan aplikasi setelah semua setup selesai.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMPN 1 Bontonompo Selatan',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Dark mode otomatis
      home: const RootPreview(),
    );
  }
}

class RootPreview extends StatelessWidget {
  const RootPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const LayoutTemplate(
      userName: 'Admin SMPN 1 Bontonompo Selatan',
      role: 'admin',
      child: DashboardHome(), // FIXED
    );
  }
}
