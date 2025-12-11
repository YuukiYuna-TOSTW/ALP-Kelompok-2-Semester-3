import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../models/menu_item_model.dart';

class DashboardSidebar extends StatelessWidget {
  final List<MenuItemModel> menuItems;
  final String selectedRoute;

  const DashboardSidebar({
    super.key,
    required this.menuItems,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================== LOGO SEKOLAH ======================
          Row(
            children: [
              Icon(Icons.school, color: AppColors.primary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "SMPN 1\nBontonompo Selatan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          // ====================== MENU UTAMA ======================
          ...menuItems.map((item) {
            final bool active = selectedRoute == item.route;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary.withOpacity(.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: active ? AppColors.primary : AppColors.textGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: active
                              ? AppColors.primary
                              : AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // ====================== USER + SETTINGS ======================
          const Divider(height: 30),

          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text("Akun Saya", style: TextStyle(fontSize: 14)),
              const Spacer(),
              const Icon(Icons.settings, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
