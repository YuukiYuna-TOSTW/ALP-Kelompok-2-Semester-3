import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/typography.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      alignment: Alignment.center,
      child: Text(
        "© 2025 SchoolSuite • All Rights Reserved",
        style: AppTypography.small.copyWith(color: AppColors.textGrey),
      ),
    );
  }
}
