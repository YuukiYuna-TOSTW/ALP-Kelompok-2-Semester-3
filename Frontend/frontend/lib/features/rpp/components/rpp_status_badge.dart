import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class RppStatusBadge extends StatelessWidget {
  final String status;

  const RppStatusBadge({super.key, required this.status});

  Color get bg {
    switch (status) {
      case "Draft":
        return Colors.grey.shade300;
      case "Menunggu Review":
        return Colors.blue.shade100;
      case "Revisi":
        return Colors.red.shade100;
      case "Disetujui":
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color get fg {
    switch (status) {
      case "Draft":
        return Colors.grey.shade800;
      case "Menunggu Review":
        return AppColors.primary;
      case "Revisi":
        return Colors.red;
      case "Disetujui":
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
