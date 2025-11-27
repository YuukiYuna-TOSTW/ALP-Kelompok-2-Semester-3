import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  final Color darkBlue = const Color.fromARGB(255, 83, 150, 227);
  final Color lightBlue = const Color.fromARGB(255, 133, 199, 249);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      color: darkBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO + NAMA SEKOLAH
          Row(
            children: [
              Image.asset('assets/logo.png', height: 50),
              const SizedBox(width: 12),
              const Text(
                'SMPN 1 Bontonompo Selatan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // MENU NAVIGASI
          if (width > 800)
            Row(
              children: [
                _navItem('Beranda'),
                _navItem('Tentang'),
                _navItem('Informasi'),
                const SizedBox(width: 20),
                _searchBox(),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      width: 180,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari...',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
