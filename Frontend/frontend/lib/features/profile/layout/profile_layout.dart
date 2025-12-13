import 'package:flutter/material.dart';
import '../../rpp/layout/rpp_layout.dart';

class ProfileLayout extends StatelessWidget {
  final Widget content;
  final String role; // admin / guru / kepsek

  const ProfileLayout({super.key, required this.content, required this.role});

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: role,
      selectedRoute: "/profile",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: content,
        ),
      ),
    );
  }
}
