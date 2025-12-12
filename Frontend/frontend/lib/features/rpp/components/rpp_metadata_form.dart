import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class RppMetadataForm extends StatelessWidget {
  final TextEditingController mapelCtrl;
  final TextEditingController kelasCtrl;
  final TextEditingController babCtrl;
  final TextEditingController semesterCtrl;

  const RppMetadataForm({
    super.key,
    required this.mapelCtrl,
    required this.kelasCtrl,
    required this.babCtrl,
    required this.semesterCtrl,
  });

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 14, // lebih kecil
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400), // abu-abu
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: mapelCtrl,
                decoration: _inputDecoration("Mata Pelajaran"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: kelasCtrl,
                decoration: _inputDecoration("Kelas"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: babCtrl,
                decoration: _inputDecoration("Bab / Materi"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: semesterCtrl,
                decoration: _inputDecoration("Semester"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
