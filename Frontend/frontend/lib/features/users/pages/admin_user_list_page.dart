import 'package:flutter/material.dart';
import '../../rpp/layout/rpp_layout.dart';
import '../widgets/user_filter_card.dart';
import '../widgets/user_table.dart';
import '../../../../config/theme/colors.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  final List<Map<String, dynamic>> allUsers = [
    {"nama": "Budi Santoso", "nip": "123456", "role": "Guru", "active": true},
    {"nama": "Siti Aminah", "nip": "654321", "role": "Kepsek", "active": true},
    {"nama": "Ahmad", "nip": "111222", "role": "Guru", "active": false},
  ];

  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(allUsers);
  }

  // ================= SEARCH =================
  void _onSearch(String query) {
    final q = query.toLowerCase();

    setState(() {
      filteredUsers = allUsers.where((u) {
        return u["nama"].toLowerCase().contains(q) ||
            u["nip"].toLowerCase().contains(q);
      }).toList();
    });
  }

  // ================= DELETE =================
  void _deleteUser(Map<String, dynamic> user) {
    setState(() {
      allUsers.remove(user);
      filteredUsers.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "admin",
      selectedRoute: "/admin/users",
      content: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardHeader(context),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      UserFilterCard(onSearch: _onSearch),
                      const SizedBox(height: 12),

                      // 🔥 KIRIM CALLBACK DELETE
                      AdminUserTable(
                        users: filteredUsers,
                        onDelete: _deleteUser,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _cardHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.85)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Manajemen Pengguna",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, "/admin/users/add"),
            icon: const Icon(Icons.add),
            label: const Text(
              "Tambah Pengguna",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
