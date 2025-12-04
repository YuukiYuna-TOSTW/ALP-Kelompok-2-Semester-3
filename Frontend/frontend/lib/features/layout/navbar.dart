import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String role;

  const TopBar({super.key, required this.userName, this.role = "guru"});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 850;

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🍔 Mobile menu button
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),

          // 📌 Title / Page Name
          Text(
            "Dashboard",
            style: AppTypography.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // 🔔 Notification button
          if (!isMobile) _buildIconButton(Icons.notifications, "notif"),

          const SizedBox(width: 8),

          // ⚙ Settings button
          if (!isMobile) _buildIconButton(Icons.settings, "settings"),

          const SizedBox(width: 12),

          // 👤 User profile dropdown
          if (!isMobile) _buildUserProfileDropdown(),
        ],
      ),
    );
  }

  // 🔘 Reusable icon button
  Widget _buildIconButton(IconData icon, String key) {
    return InkWell(
      onTap: () {
        debugPrint("$key clicked");
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // 👤 Profile + Dropdown menu
  Widget _buildUserProfileDropdown() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        debugPrint("Selected: $value");
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "profile",
          child: Row(
            children: const [
              Icon(Icons.person, size: 20),
              SizedBox(width: 10),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "settings",
          child: Row(
            children: const [
              Icon(Icons.settings, size: 20),
              SizedBox(width: 10),
              Text("Settings"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "logout",
          child: Row(
            children: const [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 10),
              Text("Logout"),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                role.capitalize(),
                style: AppTypography.small.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

// 🔤 Capitalize Extension
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
