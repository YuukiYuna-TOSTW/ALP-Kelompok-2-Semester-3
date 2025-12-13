import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class DashboardNavbar extends StatelessWidget {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),

      child: Row(
        children: [
          // SEARCH BAR
          SizedBox(
            width: 360,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, size: 20),
                  hintText: "Cari...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Spacer(),

          // NOTIFICATION
          Icon(Icons.notifications_none, color: AppColors.textDark),
          const SizedBox(width: 20),

          // SETTINGS MENU
          _settingsMenu(context),
          const SizedBox(width: 20),

          // PROFILE AVATAR
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // SETTINGS POPUP MENU
  // ======================================================
  Widget _settingsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings, color: AppColors.textDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == "profile") {
          Navigator.pushNamed(context, "/profile/edit");
        } else if (value == "password") {
          Navigator.pushNamed(context, "/profile/password");
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "profile",
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text("Edit Profil"),
          ),
        ),
        const PopupMenuItem(
          value: "password",
          child: ListTile(
            leading: Icon(Icons.lock),
            title: Text("Ganti Password"),
          ),
        ),
      ],
    );
  }
}
