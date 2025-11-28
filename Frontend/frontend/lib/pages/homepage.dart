import 'package:flutter/material.dart';
import '../widgets/homepagenavbar.dart';
import '../widgets/homepagefooter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Palette
  final Color bgColor = const Color(0xFFFBFBFB);
  final Color primaryColor = const Color(0xFF75CFFF);
  final Color cardColor = const Color(0xFFF3F3F3);

  final PageController _pageController = PageController();
  int currentIndex = 0;

  // Slides yang digunakan
  final List<Map<String, String>> heroItems = [
    {
      'image': 'assets/images/gedung.jpg',
      'title': 'Selamat Datang di SMPN 1 Bontonompo Selatan',
      'subtitle':
          'Website resmi sekolah — pusat layanan informasi akademik dan kegiatan sekolah.',
      'action': 'about',
    },
    {
      'image': 'assets/images/kegiatan1.jpg',
      'title': 'Aktivitas & Kegiatan Siswa',
      'subtitle':
          'Galeri kegiatan siswa, ekstrakurikuler, dan program sekolah.',
      'action': 'informasi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  // Auto slider
  void _startAutoSlider() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      currentIndex = (currentIndex + 1) % heroItems.length;
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _startAutoSlider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      endDrawer: buildMobileDrawer(context),

      body: Column(
        children: [
          const Navbar(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroBanner(),

                  const SizedBox(height: 40),

                  // ================= INFO SINGKAT SEKOLAH =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "SMPN 1 Bontonompo Selatan merupakan sekolah yang mengutamakan "
                        "disiplin, karakter, dan lingkungan belajar yang aktif serta nyaman. "
                        "Sekolah ini berkomitmen memberikan pendidikan berkualitas bagi seluruh siswa.",
                        style: TextStyle(fontSize: 17, height: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= KEGIATAN TERBARU =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kegiatan Terbaru",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            _activityCard(
                              'assets/images/kegiatan1.jpg',
                              "Lomba Pramuka Tingkat Kabupaten",
                            ),
                            const SizedBox(width: 20),
                            _activityCard(
                              'assets/images/kegiatan2.jpg',
                              "Senam Sehat Jumat Pagi",
                            ),
                            const SizedBox(width: 20),
                            _activityCard(
                              'assets/images/kegiatan3.jpg',
                              "Peringatan Hari Guru 2025",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= CONTACT SECTION =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: ContactSection(
                      bgColor: bgColor,
                      cardColor: cardColor,
                      primaryColor: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HERO BANNER =================
  Widget _buildHeroBanner() {
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: heroItems.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (_, index) {
              final item = heroItems[index];
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item['image']!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.35),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 520,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['subtitle']!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Tombol lihat detail
                          ElevatedButton(
                            onPressed: () {
                              if (item['action'] == 'about') {
                                Navigator.pushNamed(context, '/tentang');
                              } else {
                                Navigator.pushNamed(context, '/informasi');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Lihat Detail"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // DOTS
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(heroItems.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == i ? 22 : 10,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == i ? primaryColor : Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD KEGIATAN =================
  Widget _activityCard(String img, String title) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.25),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SIMPLE CONTACT SECTION =================
class ContactSection extends StatelessWidget {
  final Color bgColor;
  final Color cardColor;
  final Color primaryColor;

  const ContactSection({
    required this.bgColor,
    required this.cardColor,
    required this.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hubungi Kami",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.black87),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Jl. Contoh No. 123, Bontonompo Selatan",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: const [
              Icon(Icons.phone, color: Colors.black87),
              SizedBox(width: 10),
              Text("(+62) 812-3456-7890", style: TextStyle(fontSize: 15)),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: const [
              Icon(Icons.email_outlined, color: Colors.black87),
              SizedBox(width: 10),
              Text(
                "admin@smpn1-bontonompo.sch.id",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
