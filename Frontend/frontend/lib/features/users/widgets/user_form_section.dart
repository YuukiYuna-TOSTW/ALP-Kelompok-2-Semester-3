import 'package:flutter/material.dart';

class UserFormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const UserFormSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.only(bottom: 22),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TITLE =================
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 12),

            // ================= FORM CONTENT =================
            Column(
              children: children
                  .map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: w,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
