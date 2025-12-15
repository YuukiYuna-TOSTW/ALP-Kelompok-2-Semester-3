import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListView.separated(
        itemCount: 10,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text("Nama Lengkap"),
            subtitle: const Text("NIP: 123456"),
            trailing: Wrap(
              spacing: 6,
              children: [
                _icon(Icons.edit, AppColors.primary, () {
                  Navigator.pushNamed(context, "/admin/users/edit");
                }),
                _icon(Icons.lock_reset, Colors.orange, () {}),
                _icon(Icons.delete, Colors.red, () {}),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _icon(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onTap,
    );
  }
}
