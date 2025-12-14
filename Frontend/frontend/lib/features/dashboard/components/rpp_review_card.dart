import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class RppReviewCard extends StatelessWidget {
  final String subject;
  final String className;
  final String teacher;
  final String time;
  final VoidCallback onReview;

  const RppReviewCard({
    super.key,
    required this.subject,
    required this.className,
    required this.teacher,
    required this.time,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RPP $subject $className – Menunggu Review",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Upload oleh: $teacher • $time",
            style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onReview, // ✅ INI INTINYA
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Review Sekarang",
                style: TextStyle(color: Colors.white, fontSize: 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
