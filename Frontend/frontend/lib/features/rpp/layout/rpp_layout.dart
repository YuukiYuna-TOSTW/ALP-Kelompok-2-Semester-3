import 'package:flutter/material.dart';
import '../../dashboard/layout/sidebar.dart';
import '../../dashboard/layout/footer.dart';
import '../../../core/menu/role_menu_config.dart';
import '../../../../config/theme/colors.dart';

class RppLayout extends StatelessWidget {
  final Widget content;
  final String role;
  final String selectedRoute;

  const RppLayout({
    super.key,
    required this.content,
    required this.role,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = RoleMenuConfig.getMenu(role);

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // 🔵 SIDEBAR — FIXED
          // =====================================================
          DashboardSidebar(selectedRoute: selectedRoute, menuItems: menuItems),

          // =====================================================
          // ⚪ AREA KONTEN (scrollable)
          // =====================================================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------------------
                  // CONTENT DI BAGIAN TENGAH
                  // -------------------------------
                  Padding(padding: const EdgeInsets.all(24), child: content),

                  const SizedBox(height: 40),

                  // -------------------------------
                  // FOOTER — seperti dashboard
                  // -------------------------------
                  Container(
                    width: double.infinity,
                    color: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 26,
                    ),
                    child: const DashboardFooter(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
