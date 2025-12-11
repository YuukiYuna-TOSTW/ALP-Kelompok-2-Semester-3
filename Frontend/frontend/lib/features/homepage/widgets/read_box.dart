import 'package:flutter/material.dart';

class ReadBox extends StatelessWidget {
  final String value;

  const ReadBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }
}
