import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class ScheduleCard extends StatelessWidget {
  final String time;
  final String subject;
  final String className;
  final String room;

  const ScheduleCard({
    super.key,
    required this.time,
    required this.subject,
    required this.className,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),

        Expanded(
          child: Text(
            "$time • $subject • $className • $room",
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
