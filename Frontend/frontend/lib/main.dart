import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'config/theme/app_theme.dart';

import 'features/layout/layout_template.dart';
import 'features/dashboard/pages/dashboard_page.dart'; // FIXED PATH
=======
//import 'features/homepage/pages/homepage.dart';
//import 'features/homepage/pages/tambah_kegiatan.dart';
import 'features/homepage/pages/otp_verification_screen.dart';
//import 'features/homepage/pages/otp_verification_screen.dart';
// import 'features/homepage/pages/otp_verification_screen.dart';
// import '../../../widgets/otp_timer.dart';
>>>>>>> autentikasi_login

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
<<<<<<< HEAD

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
=======
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF75CFFF),
      ),
      home: OtpVerificationPage(),
>>>>>>> autentikasi_login
    );
  }
}
