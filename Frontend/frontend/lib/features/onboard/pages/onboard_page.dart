import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> data = [
    {
      'title': 'Kelola Roster Mudah',
      'desc': 'Atur jadwal guru dan sekolah tanpa ribet',
    },
    {
      'title': 'Auto Mingguan',
      'desc': 'Hari yang sudah lewat otomatis hilang',
    },
    {
      'title': 'Siap Mengajar',
      'desc': 'Pantau jadwal langsung hari ini',
    },
  ];

  // Use app theme colors for consistency
  // (AppColors.primary / AppColors.secondary)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: data.length,
                  onPageChanged: (i) {
                    setState(() => _currentPage = i);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 120,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            data[index]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data[index]['desc']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  data.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == data.length - 1) {
                        Navigator.pushReplacementNamed(context, '/roster');
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _currentPage == data.length - 1
                          ? 'Masuk'
                          : 'Lanjut',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
