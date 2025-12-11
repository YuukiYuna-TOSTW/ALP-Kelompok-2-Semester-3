import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/sidebar.dart';
import '../layout/footer.dart';
import '../role_config/role_menu.dart';

class DashboardLayout extends StatelessWidget {
  final String role;
  final String selectedRoute;
  final Widget content; // kolom tengah
  final Widget rightPanel; // kolom kanan

  const DashboardLayout({
    super.key,
    required this.role,
    required this.selectedRoute,
    required this.content,
    required this.rightPanel,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = RoleMenuConfig.getMenu(role);

    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // 🟦 SIDEBAR — FIXED
          // =====================================================
          DashboardSidebar(menuItems: menuItems, selectedRoute: selectedRoute),

          // =====================================================
          // ⚪ AREA TENGAH + KANAN (Scroll Bersama)
          // =====================================================
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------------
                  // MAIN ROW
                  // --------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KONTEN TENGAH
                        Expanded(flex: 4, child: content),

                        const SizedBox(width: 24),

                        // PANEL KANAN
                        SizedBox(width: 300, child: rightPanel),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --------------------------
                  // FOOTER (hanya di bawah scroll)
                  // --------------------------
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
