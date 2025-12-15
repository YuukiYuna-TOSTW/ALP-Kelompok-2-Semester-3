import 'package:flutter/material.dart';

class UserFilterCard extends StatelessWidget {
  final Function(String) onSearch;

  const UserFilterCard({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Role"),
                items: const [
                  DropdownMenuItem(value: "Guru", child: Text("Guru")),
                  DropdownMenuItem(value: "Kepsek", child: Text("Kepsek")),
                  DropdownMenuItem(value: "Wakasek", child: Text("Wakasek")),
                ],
                onChanged: (_) {},
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "Aktif", child: Text("Aktif")),
                  DropdownMenuItem(value: "Nonaktif", child: Text("Nonaktif")),
                ],
                onChanged: (_) {},
              ),
            ),

            const SizedBox(width: 16),

            // 🔥 SEARCH BAR LEBAR & FLEXIBLE
            Expanded(
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: "Cari Nama / NIP",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
