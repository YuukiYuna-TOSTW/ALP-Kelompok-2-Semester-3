import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/developer_item.dart';
import '../widgets/contact_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "by Nama Web",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(width: 6),
                const Text("·", style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                const Text(
                  "Published 12/10/2025",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
            ),

            const SizedBox(height: 20),

            const Text(
              "Sekolah bukan hanya tempat belajar, tetapi tempat kita menemukan jati diri sedikit demi sedikit. "
              "Di setiap tugas dan tantangan, kita diajari untuk lebih kuat dan tidak mudah menyerah. "
              "Teman, guru, dan setiap momen kecil di dalamnya membentuk cara kita melihat dunia. "
              "Dan kelak, kenangan tentang perjuangan di sekolah menjadi bagian penting dari perjalanan hidup kita.",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, height: 1.4),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "Our Developer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DAFF5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DeveloperItem(name: "Aristo"),
                DeveloperItem(name: "Wyat"),
                DeveloperItem(name: "Gladys"),
                DeveloperItem(name: "Stella"),
                DeveloperItem(name: "Gerar"),
                DeveloperItem(name: "Rasya"),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      Text(
                        "Berawal dari pengambilan nilai proyek akhir Semester 3, kami mahasiswa UC IMT melakukan observasi langsung ke Desa Sengka sebagai bagian dari tugas studi lapangan...",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Minimnya fasilitas digital seperti laboratorium komputer yang sudah tidak berfungsi juga memperparah kondisi tersebut...",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  flex: 1,
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Dokumentasi Sekolah",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Harapan Kami",
                  style: TextStyle(
                    color: Color(0xFF4DAFF5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "• Pendidikan yang baik membutuhkan dukungan teknologi yang memadai agar proses administrasi dan pembelajaran berjalan efektif.",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                SizedBox(height: 5),

                Text(
                  "• Guru tidak seharusnya terbebani oleh proses administratif manual...",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                SizedBox(height: 5),

                Text(
                  "• Teknologi digital dan AI mampu menjadi solusi nyata...",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                SizedBox(height: 5),

                Text(
                  "• Solusi digital di SMPN 1 Bontonompo Selatan diyakini dapat memberikan dampak positif...",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
                SizedBox(height: 5),

                Text(
                  "• Digitalisasi juga berperan penting dalam meningkatkan kualitas pembelajaran...",
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),

                SizedBox(height: 30),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              "Hubungi Kami",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4DAFF5),
              ),
            ),

            const SizedBox(height: 15),

            ContactItem(
              icon: FontAwesomeIcons.whatsapp,
              text: "WhatsApp: 08xxxxxxxxxx",
            ),
            const SizedBox(height: 8),

            ContactItem(icon: Icons.email, text: "Gmail: sekolah@example.com"),
            const SizedBox(height: 8),

            ContactItem(
              icon: FontAwesomeIcons.instagram,
              text: "Instagram: @nama_sekolah",
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
