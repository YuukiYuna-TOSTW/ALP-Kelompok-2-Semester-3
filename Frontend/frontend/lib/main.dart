import 'package:flutter/material.dart';
//import 'features/homepage/pages/homepage.dart';
//import 'features/homepage/pages/tambah_kegiatan.dart';
import 'features/homepage/pages/otp_verification_screen.dart';
//import 'features/homepage/pages/otp_verification_screen.dart';
// import 'features/homepage/pages/otp_verification_screen.dart';
// import '../../../widgets/otp_timer.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF75CFFF),
      ),
      home: OtpVerificationPage(),
    );
  }
}
