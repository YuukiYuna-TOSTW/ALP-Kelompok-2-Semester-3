import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../homepage/widgets/developer_item.dart';
import '../../homepage/widgets/contact_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color primary = Color(0xFF4DAFF5);
  static const Color softBg = Color(0xFFF5F8FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _heroHeader(context),
            const SizedBox(height: 40),
            _mainCard(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // HERO HEADER
  // =====================================================
  Widget _heroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, Color(0xFF75CFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            "About Us",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Mengenal lebih dekat visi, cerita, dan orang-orang\n"
            "di balik sistem digital SMPN 1 Bontonompo Selatan",
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MAIN CARD
  // =====================================================
  Widget _mainCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _meta(),
                const SizedBox(height: 30),
                _introText(),
                const SizedBox(height: 50),
                _sectionTitle("Our Developers"),
                const SizedBox(height: 25),
                _developerGrid(),
                const SizedBox(height: 60),
                _storySection(),
                const SizedBox(height: 60),
                _hopeSection(),
                const SizedBox(height: 60),
                _contactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // META
  // =====================================================
  Widget _meta() {
    return Row(
      children: const [
        Icon(Icons.school, size: 18, color: primary),
        SizedBox(width: 8),
        Text("by Nama Web"),
        SizedBox(width: 8),
        Text("•"),
        SizedBox(width: 8),
        Text("Published 12/10/2025"),
      ],
    );
  }

  // =====================================================
  // INTRO
  // =====================================================
  Widget _introText() {
    return Text(
      "Sekolah bukan hanya tempat belajar, tetapi tempat kita menemukan jati diri sedikit demi sedikit. "
      "Di setiap tugas dan tantangan, kita diajari untuk lebih kuat dan tidak mudah menyerah. "
      "Teman, guru, dan setiap momen kecil di dalamnya membentuk cara kita melihat dunia.\n\n"
      "Kami percaya bahwa teknologi bukan untuk menggantikan peran guru, "
      "melainkan untuk mendukung dan mempermudah proses pendidikan agar lebih manusiawi dan bermakna.",
      style: const TextStyle(fontSize: 15, height: 1.7),
    );
  }

  // =====================================================
  // SECTION TITLE
  // =====================================================
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
    );
  }

  // =====================================================
  // DEVELOPERS
  // =====================================================
  Widget _developerGrid() {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      alignment: WrapAlignment.center,
      children: const [
        DeveloperItem(name: "Aristo"),
        DeveloperItem(name: "Wyat"),
        DeveloperItem(name: "Gladys"),
        DeveloperItem(name: "Stella"),
        DeveloperItem(name: "Gerar"),
        DeveloperItem(name: "Rasya"),
      ],
    );
  }

  // =====================================================
  // STORY
  // =====================================================
  Widget _storySection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Perjalanan Kami",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              SizedBox(height: 14),
              Text(
                "Berawal dari proyek akhir Semester 3, kami mahasiswa UC IMT "
                "melakukan observasi langsung ke Desa Sengka sebagai bagian dari "
                "studi lapangan.\n\n"
                "Minimnya fasilitas digital seperti laboratorium komputer yang "
                "sudah tidak berfungsi membuat proses administrasi dan pembelajaran "
                "menjadi kurang optimal.",
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 1,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text("Dokumentasi Sekolah")),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // HOPE
  // =====================================================
  Widget _hopeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Harapan Kami",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        SizedBox(height: 16),
        _HopeItem(
          text:
              "Menyediakan sistem administrasi digital yang efisien dan mudah digunakan.",
        ),
        _HopeItem(
          text:
              "Mengurangi beban administratif guru agar lebih fokus mengajar.",
        ),
        _HopeItem(
          text:
              "Memanfaatkan AI sebagai asisten pendidikan, bukan pengganti manusia.",
        ),
        _HopeItem(
          text: "Mendorong transformasi digital sekolah secara berkelanjutan.",
        ),
      ],
    );
  }

  // =====================================================
  // CONTACT
  // =====================================================
  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Hubungi Kami",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        SizedBox(height: 20),
        ContactItem(
          icon: FontAwesomeIcons.whatsapp,
          text: "WhatsApp: 08xxxxxxxxxx",
        ),
        SizedBox(height: 10),
        ContactItem(icon: Icons.email, text: "Email: sekolah@example.com"),
        SizedBox(height: 10),
        ContactItem(
          icon: FontAwesomeIcons.instagram,
          text: "Instagram: @nama_sekolah",
        ),
      ],
    );
  }
}

// =====================================================
// HOPE ITEM
// =====================================================
class _HopeItem extends StatelessWidget {
  final String text;
  const _HopeItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4DAFF5), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
