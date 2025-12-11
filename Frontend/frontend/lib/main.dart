import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/theme/app_theme.dart';
import 'features/layout/layout_template.dart';
import 'features/dashboard/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      themeMode: ThemeMode.system,
      // Pilih home page yang ingin digunakan:
      // Opsi 1: Dashboard
      home: const RootPreview(),
      // Opsi 2: OTP Verification
      // home: OtpVerificationPage(),
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
      child: DashboardHome(),
    );
  }
}
