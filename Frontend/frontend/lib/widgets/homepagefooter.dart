import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  final Color darkBg = const Color(0xFF2F4156); // Dark navy/grey
  final Color primary = const Color(0xFF75CFFF);
  final Color textLight = Colors.white;
  final Color textMuted = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: darkBg,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================== TOP CONTENT (3 Columns) ======================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLUMN 1 - SCHOOL INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SMPN 1 Bontonompo Selatan",
                      style: TextStyle(
                        color: textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Website resmi sekolah sebagai pusat informasi akademik, kegiatan, dan layanan digital untuk siswa, guru, dan masyarakat.",
                      style: TextStyle(color: textMuted, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 50),

              // COLUMN 2 - QUICK NAVIGATION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Navigasi",
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    footerLink("Beranda"),
                    footerLink("Tentang"),
                    footerLink("Informasi"),
                    footerLink("Kontak"),
                  ],
                ),
              ),

              const SizedBox(width: 50),

              // COLUMN 3 - CONTACT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kontak",
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    rowIconText(
                      Icons.location_on,
                      "Jl. Contoh No. 123, Bontonompo Selatan",
                    ),
                    const SizedBox(height: 8),

                    rowIconText(Icons.phone, "(+62) 812-3456-7890"),
                    const SizedBox(height: 8),

                    rowIconText(
                      Icons.email_outlined,
                      "admin@smpn1-bontonompo.sch.id",
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          // ====================== LINE DIVIDER ======================
          Container(width: double.infinity, height: 1, color: Colors.white30),

          const SizedBox(height: 20),

          // ====================== COPYRIGHT ======================
          Center(
            child: Text(
              "© 2025 SMPN 1 Bontonompo Selatan — All Rights Reserved",
              style: TextStyle(color: textMuted),
            ),
          ),
        ],
      ),
    );
  }

  // FOOTER LINK STYLE
  Widget footerLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }

  // CONTACT ROW
  Widget rowIconText(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}
