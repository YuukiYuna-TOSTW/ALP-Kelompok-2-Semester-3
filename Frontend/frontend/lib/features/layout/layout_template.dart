import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../role_config/role_menu.dart';
import 'sidebar.dart';
import 'topbar.dart';
import 'footer.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  final String userName;
  final String role;

  const LayoutTemplate({
    super.key,
    required this.child,
    this.userName = "User",
    this.role = "guru",
  });

  @override
  Widget build(BuildContext context) {
    final menu = RoleMenuConfig.getMenu(role);

    return Scaffold(
      backgroundColor: AppColors.background,

      // Drawer untuk mobile
      drawer: MediaQuery.of(context).size.width <= 850
          ? Drawer(child: Sidebar(menuItems: menu))
          : null,

      body: Row(
        children: [
          // Sidebar untuk desktop/tablet
          if (MediaQuery.of(context).size.width > 850) Sidebar(menuItems: menu),

          // Konten sebelah kanan
          Expanded(
            child: Column(
              children: [
                TopBar(userName: userName),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: child,
                  ),
                ),

                const AppFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
