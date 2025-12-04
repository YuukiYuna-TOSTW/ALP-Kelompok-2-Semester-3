import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import 'navbar.dart';
import 'footer.dart';
import 'mobile_navigation_drawer.dart';

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
    final bool isMobile = MediaQuery.of(context).size.width <= 850;

    return Scaffold(
      backgroundColor: AppColors.background,

      // Drawer untuk mobile
      drawer: isMobile
          ? Drawer(child: MobileNavigationDrawer(role: role))
          : null,

      body: Column(
        children: [
          // NAVBAR
          TopBar(userName: userName, role: role),

          // HALAMAN
          Expanded(
            child: Padding(padding: const EdgeInsets.all(20), child: child),
          ),

          // FOOTER
          const AppFooter(),
        ],
      ),
    );
  }
}
