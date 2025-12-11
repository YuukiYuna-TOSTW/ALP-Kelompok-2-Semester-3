import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: const BoxDecoration(color: AppColors.primary),

      child: Column(
        children: [
          // ============================
          // ROW UTAMA
          // ============================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🏫 ALAMAT
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    "SMP Negeri 1 Bontonompo Selatan • Sengka, Bontonompo Selatan, Gowa",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),

              // 🌐 SOCIAL ICONS
              Row(
                children: const [
                  Icon(Icons.language, size: 20, color: Colors.white),
                  SizedBox(width: 14),
                  Icon(Icons.facebook_rounded, size: 20, color: Colors.white),
                  SizedBox(width: 14),
                  Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                  SizedBox(width: 14),
                  Icon(
                    Icons.play_circle_fill_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                  SizedBox(width: 14),
                ],
              ),

              // 🤖 AI SUPPORT
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Garis tipis pemisah
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),

          const SizedBox(height: 10),

          const Text(
            "© 2025 Sistem Akademik SMP Negeri 1 Bontonompo Selatan",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
