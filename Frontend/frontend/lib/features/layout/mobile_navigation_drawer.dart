import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';

class MobileNavigationDrawer extends StatelessWidget {
  final String role;

  const MobileNavigationDrawer({super.key, this.role = "guru"});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.95),
              AppColors.primary.withOpacity(0.85),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),

            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary, size: 40),
            ),

            const SizedBox(height: 12),

            Text(
              "Welcome",
              style: AppTypography.h3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              role.capitalize(),
              style: AppTypography.body.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),

            const SizedBox(height: 30),

            // contoh menu aesthetic
            _drawerButton(Icons.dashboard_outlined, "Dashboard", () {}),
            _drawerButton(Icons.schedule_rounded, "Jadwal", () {}),
            _drawerButton(Icons.menu_book_outlined, "RPP", () {}),
            _drawerButton(Icons.logout, "Logout", () {}),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "© 2025 SchoolSuite",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerButton(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: AppTypography.body.copyWith(color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }
}

// Extension kapitalisasi
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
