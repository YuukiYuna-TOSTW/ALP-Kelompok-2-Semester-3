import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class RppSectionEditor extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onAiPressed;

  const RppSectionEditor({
    super.key,
    required this.title,
    required this.controller,
    this.readOnly = false,
    this.onAiPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + Tombol AI
        Row(
          children: [
            if (title.isNotEmpty)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            const Spacer(),
            if (!readOnly && onAiPressed != null)
              TextButton(onPressed: onAiPressed, child: const Text("Bantu AI")),
          ],
        ),

        // Input Box
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 6),
            ],
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: null,
            decoration: const InputDecoration.collapsed(
              hintText: "Tulis di sini...",
              hintStyle: TextStyle(
                color: Colors.grey, // <-- ABU-ABU
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
