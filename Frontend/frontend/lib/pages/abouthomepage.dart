import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color lightBlue = const Color(0xFFC8D9E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Navbar(),

          // ================= HERO SECTION =================
          Expanded(
            child: Container(
              width: double.infinity,
              color: lightBlue,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Selamat Datang di',
                      style: TextStyle(fontSize: 24, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'SMPN 1 Bontonompo Selatan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4156),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Website Resmi Informasi Sekolah',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}
