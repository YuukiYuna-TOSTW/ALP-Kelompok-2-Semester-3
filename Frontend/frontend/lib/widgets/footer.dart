import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  final Color darkBlue = const Color.fromARGB(255, 83, 150, 227);
  final Color lightBlue = const Color.fromARGB(255, 133, 199, 249);

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
