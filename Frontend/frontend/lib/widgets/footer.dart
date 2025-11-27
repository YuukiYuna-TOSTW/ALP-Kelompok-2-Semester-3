import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  final Color darkBlue = const Color(0xFF2F4156);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      color: darkBlue,
      child: const Center(
        child: Text(
          '© 2025 SMPN 1 Bontonompo Selatan | All Rights Reserved',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
