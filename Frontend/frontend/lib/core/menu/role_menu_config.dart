import 'package:flutter/material.dart';
import '../../features/dashboard/models/menu_item_model.dart';

class RoleMenuConfig {
  static List<MenuItemModel> getMenu(String role) {
    switch (role) {
      case "admin":
        return adminMenu;

      case "kepsek":
      case "wakasek":
        return kepsekMenu;

      case "guru":
      default:
        return guruMenu;
    }
  }

  // ================================
  // ⭐ ADMIN
  // ================================
  static final List<MenuItemModel> adminMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),
    MenuItemModel("Jadwal", Icons.calendar_month_rounded, "/schedule"),
    MenuItemModel("Data Guru & Kelas", Icons.people_alt_rounded, "/management"),
    MenuItemModel("RPP", Icons.menu_book_rounded, "/rpp"),
    MenuItemModel("Pengumuman", Icons.campaign_rounded, "/announcement"),
    MenuItemModel(
      "Notifikasi",
      Icons.notification_add_rounded,
      "/notifications",
    ),
  ];

  // ================================
  // ⭐ KEPSEK / WAKASEK
  // ================================
  static final List<MenuItemModel> kepsekMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),
    MenuItemModel("RPP", Icons.menu_book_rounded, "/rpp"),
    MenuItemModel("Review", Icons.fact_check_rounded, "/review"),
    MenuItemModel(
      "Jadwal Sekolah",
      Icons.calendar_view_month_rounded,
      "/schedule",
    ),
    MenuItemModel("Pengumuman", Icons.campaign_rounded, "/announcement"),
    MenuItemModel(
      "Notifikasi",
      Icons.notification_add_rounded,
      "/notifications",
    ),
  ];

  // ================================
  // ⭐ GURU
  // ================================
  static final List<MenuItemModel> guruMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),
    MenuItemModel("Jadwal", Icons.calendar_today_rounded, "/schedule"),
    MenuItemModel("RPP", Icons.menu_book_rounded, "/rpp"),
    MenuItemModel(
      "Notifikasi",
      Icons.notification_add_rounded,
      "/notifications",
    ),
  ];

  // ========================================
  // ⭐ PERMISSION KHUSUS HALAMAN RPP
  // ========================================
  static final Map<String, List<String>> rppPermissions = {
    "admin": ["/rpp", "/rpp/create", "/rpp/history", "/rpp/review"],

    "kepsek": ["/rpp", "/rpp/review", "/rpp/history"],

    "guru": ["/rpp", "/rpp/create", "/rpp/history"],
  };
}
