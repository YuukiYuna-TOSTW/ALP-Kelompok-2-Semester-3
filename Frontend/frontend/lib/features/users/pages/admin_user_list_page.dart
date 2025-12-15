import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../widgets/user_filter_card.dart';
import '../widgets/user_table.dart';

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Daftar Data Pengguna",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/admin/users/add"),
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Pengguna"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // FILTER
            const UserFilterCard(),

            const SizedBox(height: 16),

            // TABLE
            const Expanded(child: UserTable()),
          ],
        ),
      ),
    );
  }
}
