import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color lightBlue = const Color(0xFFC8D9E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ BACKGROUND PUTIH
      body: Column(
        children: [
          const Navbar(),

          // ================= HERO SECTION =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Row(
                children: [
                  // ========== TEKS SELAMAT DATANG ==========
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Selamat Datang di',
                          style: TextStyle(fontSize: 22, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'SMPN 1 Bontonompo Selatan',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F4156),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Website Resmi Informasi Sekolah\nSebagai pusat layanan informasi akademik dan kegiatan sekolah.',
                          style: TextStyle(fontSize: 18, height: 1.5),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // ========== FOTO WELCOME ==========
                  Expanded(
                    child: Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/welcome.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}
