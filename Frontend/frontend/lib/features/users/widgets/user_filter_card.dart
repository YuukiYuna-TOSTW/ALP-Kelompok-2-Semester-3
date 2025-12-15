import 'package:flutter/material.dart';

class UserFilterCard extends StatelessWidget {
  const UserFilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _dropdown("Role"),
            _dropdown("Mapel"),
            _dropdown("Kelas"),
            _dropdown("Status"),
            SizedBox(
              width: 250,
              child: TextField(
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

  Widget _dropdown(String label) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        items: const [],
        onChanged: (_) {},
      ),
    );
  }
}
