import 'package:flutter/material.dart';
import '../../config/theme/typography.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Text(
        "© 2025 SchoolSuite • All rights reserved",
        style: AppTypography.small,
      ),
    );
  }
}
