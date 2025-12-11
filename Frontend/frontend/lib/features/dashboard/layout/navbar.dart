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

          // PROFILE
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
