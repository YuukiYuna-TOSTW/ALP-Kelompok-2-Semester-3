import 'package:flutter/material.dart';

class RoleDynamicFields extends StatelessWidget {
  final String role;
  const RoleDynamicFields({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == "Guru") {
      return Column(
        children: const [
          TextField(decoration: InputDecoration(labelText: "Mata Pelajaran")),
          TextField(decoration: InputDecoration(labelText: "Kelas Diampu")),
          TextField(decoration: InputDecoration(labelText: "Jam Mengajar")),
        ],
      );
    }

    if (role == "Kepsek" || role == "Wakasek") {
      return Column(
        children: const [
          TextField(decoration: InputDecoration(labelText: "Tahun Menjabat")),
          TextField(decoration: InputDecoration(labelText: "Tugas Utama")),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
