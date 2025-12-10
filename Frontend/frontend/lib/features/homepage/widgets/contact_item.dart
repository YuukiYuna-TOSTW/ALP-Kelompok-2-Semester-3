import 'package:flutter/material.dart';

class DeveloperItem extends StatelessWidget {
  final String name;

  const DeveloperItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF75CFFF),
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(Icons.pets, size: 30, color: Color(0xFF4DAFF5)),
          ),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
