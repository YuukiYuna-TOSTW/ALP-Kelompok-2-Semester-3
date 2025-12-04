import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';

class SidebarMobile extends StatelessWidget {
  const SidebarMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 60),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Text(
              "Menu",
              style: AppTypography.h3.copyWith(color: AppColors.textDark),
            ),
            const SizedBox(height: 30),

            _menuItem(Icons.dashboard, "Dashboard"),
            _menuItem(Icons.schedule, "Jadwal"),
            _menuItem(Icons.menu_book, "RPP"),
            _menuItem(Icons.people, "Guru"),
            _menuItem(Icons.settings, "Pengaturan"),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTypography.body),
      onTap: () {},
    );
  }
}
