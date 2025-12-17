import 'package:flutter/material.dart';

class RoleDynamicFields extends StatelessWidget {
  final String role;
  const RoleDynamicFields({super.key, required this.role});

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ================= ROLE: GURU =================
    if (role == "Guru") {
      return Column(
        children: [
          const SizedBox(height: 12),

          // Mata Pelajaran (1 baris penuh)
          TextField(
            decoration: _input("Mata Pelajaran"),
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 14),

          // Kelas & Jam Mengajar (2 kolom)
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: _input("Kelas Diampu"),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  decoration: _input("Jam Mengajar / Minggu"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // ================= ROLE: KEPSEK / WAKASEK =================
    if (role == "Kepsek" || role == "Wakasek") {
      return Column(
        children: [
          const SizedBox(height: 12),

          TextField(
            decoration: _input("Tahun Menjabat"),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 14),

          TextField(decoration: _input("Tugas Utama"), maxLines: 2),
        ],
      );
    }

    // ================= ROLE LAIN =================
    return const SizedBox.shrink();
  }
}
