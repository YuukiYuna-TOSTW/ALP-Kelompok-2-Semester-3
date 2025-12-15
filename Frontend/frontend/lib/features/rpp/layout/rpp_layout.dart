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
      body: SafeArea(
        child: Row(
          children: [
            // ================= SIDEBAR =================
            SizedBox(
              width: 260,
              child: DashboardSidebar(
                selectedRoute: selectedRoute,
                menuItems: menuItems,
              ),
            ),

            // ================= CONTENT AREA =================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ===== CONTENT (PAKAI PADDING & MAX WIDTH) =====
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: content,
                        ),
                      ),
                    ),

                    // ===== FOOTER (FULL WIDTH, MENTOK) =====
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
      ),
    );
  }
}
