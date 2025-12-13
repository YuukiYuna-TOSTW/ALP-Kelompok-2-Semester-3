import 'package:flutter/material.dart';
import 'kepsek_profile_page.dart';
import 'guru_profile_page.dart';
import 'admin_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String role;
  final Map<String, dynamic> data;

  const ProfilePage({super.key, required this.role, required this.data});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case "kepsek":
      case "wakasek":
        return KepsekProfilePage(data: data);

      case "admin":
        return AdminProfilePage(data: data);

      case "guru":
      default:
        return GuruProfilePage(data: data);
    }
  }
}
