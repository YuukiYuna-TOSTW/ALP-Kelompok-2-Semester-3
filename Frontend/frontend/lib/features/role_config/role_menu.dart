import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final IconData icon;
  final String route;

  MenuItemModel(this.title, this.icon, this.route);
}

class RoleMenuConfig {
  // ===============================
  // MENU UNTUK PER ROLE
  // ===============================

  static final Map<String, List<MenuItemModel>> menuByRole = {
    // ============================================
    // ADMIN – mengatur jadwal, RPP, user
    // ============================================
    "admin": [
      MenuItemModel("Dashboard", Icons.dashboard_outlined, "/dashboard"),
      MenuItemModel("Jadwal", Icons.schedule_outlined, "/schedule"),
      MenuItemModel(
        "Generate Jadwal",
        Icons.auto_awesome,
        "/schedule/generate",
      ),
      MenuItemModel("RPP", Icons.menu_book_outlined, "/rpp"),
      MenuItemModel("Manajemen User", Icons.people_alt_outlined, "/users"),
    ],

    // ============================================
    // GURU – melihat jadwal sendiri & RPP sendiri
    // ============================================
    "guru": [
      MenuItemModel("Dashboard", Icons.dashboard_outlined, "/dashboard"),
      MenuItemModel("Jadwal Saya", Icons.schedule_outlined, "/schedule/my"),
      MenuItemModel("RPP Saya", Icons.menu_book_outlined, "/rpp/my"),
    ],

    // ============================================
    // WAKASEK – review RPP, lihat jadwal sekolah
    // ============================================
    "wakasek": [
      MenuItemModel("Dashboard", Icons.dashboard_outlined, "/dashboard"),
      MenuItemModel("Review RPP", Icons.rate_review_outlined, "/rpp/review"),
      MenuItemModel("Jadwal Sekolah", Icons.schedule_outlined, "/schedule"),
    ],

    // ============================================
    // KEPSEK – mirip wakasek tapi akses lebih luas
    // ============================================
    "kepsek": [
      MenuItemModel("Dashboard", Icons.dashboard_outlined, "/dashboard"),
      MenuItemModel(
        "Review Semua RPP",
        Icons.rate_review_outlined,
        "/rpp/review",
      ),
      MenuItemModel("Jadwal Sekolah", Icons.schedule_outlined, "/schedule"),
      MenuItemModel("Rekap RPP", Icons.file_copy_outlined, "/rpp/rekap"),
    ],
  };

  // MENGAMBIL MENU BERDASARKAN ROLE
  static List<MenuItemModel> getMenu(String role) {
    return menuByRole[role] ?? [];
  }
}
