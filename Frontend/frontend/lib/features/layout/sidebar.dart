import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';
import '../role_config/role_menu.dart';

class Sidebar extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const Sidebar({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.sidebarBorder)),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "SchoolSuite",
              style: AppTypography.h2.copyWith(color: Colors.black87),
            ),
          ),

          Expanded(
            child: ListView(
              children: menuItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(item.icon, color: AppColors.secondary),
                    title: Text(item.title, style: AppTypography.body),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () => Navigator.pushNamed(context, item.route),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
