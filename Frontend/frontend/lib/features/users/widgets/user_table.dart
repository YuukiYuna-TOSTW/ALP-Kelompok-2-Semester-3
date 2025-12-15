import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class AdminUserTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(Map<String, dynamic>) onDelete;

  const AdminUserTable({
    super.key,
    required this.users,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 420, // 🔒 tinggi stabil
        child: users.isEmpty
            ? const Center(
                child: Text(
                  "Data tidak ditemukan",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            : ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      user["nama"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("NIP: ${user["nip"]}"),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                          tooltip: "Edit",
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/admin/users/edit",
                              arguments: user,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: "Hapus",
                          onPressed: () => _confirmDelete(context, user),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  // ================= POPUP KONFIRMASI =================
  void _confirmDelete(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Pengguna"),
        content: Text(
          "Apakah kamu yakin ingin menghapus pengguna \"${user["nama"]}\"?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(user); // 🔥 HAPUS DATA
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pengguna berhasil dihapus")),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
