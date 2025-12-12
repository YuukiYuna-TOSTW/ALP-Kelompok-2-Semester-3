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

    /// ADMIN → lihat semua RPP
    MenuItemModel("RPP Guru", Icons.menu_book_rounded, "/admin/rpp"),

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

    /// KEPSEK → lihat semua RPP
    MenuItemModel("RPP Guru", Icons.menu_book_rounded, "/kepsek/rpp"),

    /// Bisa beri review
    MenuItemModel("Review", Icons.fact_check_rounded, "/kepsek/rpp"),

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

    /// GURU → hanya RPP miliknya
    MenuItemModel("RPP Saya", Icons.menu_book_rounded, "/rpp"),

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
    // ADMIN -> hanya read all, preview, history (NO create, NO review)
    "admin": ["/admin/rpp", "/rpp/preview", "/rpp/history"],

    // KEPSEK -> lihat semua RPP + review + history
    "kepsek": [
      "/kepsek/rpp",
      "/kepsek/rpp/review",
      "/rpp/preview",
      "/rpp/history",
    ],

    // GURU -> create/edit/view/history RPP pribadi
    "guru": [
      "/rpp",
      "/rpp/create",
      "/rpp/edit",
      "/rpp/preview",
      "/rpp/history",
    ],
  };
}
