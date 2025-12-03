import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;

  const TopBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Mobile hamburger menu
          if (MediaQuery.of(context).size.width <= 850)
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, size: 26, color: AppColors.primary),
            ),

          Text("Dashboard", style: AppTypography.h3),

          const Spacer(),

          Text(userName, style: AppTypography.body),
          const SizedBox(width: 14),

          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
