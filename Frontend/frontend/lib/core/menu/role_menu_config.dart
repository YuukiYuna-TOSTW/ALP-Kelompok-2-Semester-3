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

    /// ADMIN → mengelola pengumuman
    MenuItemModel("Pengumuman", Icons.campaign_rounded, "/announcement"),

    /// PROFIL
    MenuItemModel("Profil Saya", Icons.person_rounded, "/profile"),

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

    /// Bisa mereview RPP
    MenuItemModel("Review RPP Guru", Icons.fact_check_rounded, "/kepsek/rpp"),

    MenuItemModel(
      "Jadwal Sekolah",
      Icons.calendar_view_month_rounded,
      "/schedule",
    ),

    /// Pengumuman
    MenuItemModel("Pengumuman", Icons.campaign_rounded, "/announcement"),

    MenuItemModel(
      "Notifikasi",
      Icons.notification_add_rounded,
      "/notifications",
    ),

    /// PROFIL
    MenuItemModel("Profil Saya", Icons.person_rounded, "/profile"),
  ];

  // ================================
  // ⭐ GURU
  // ================================
  static final List<MenuItemModel> guruMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),
    MenuItemModel("Jadwal", Icons.calendar_today_rounded, "/schedule"),

    /// Guru → hanya RPP pribadi
    MenuItemModel("RPP Saya", Icons.menu_book_rounded, "/rpp"),

    /// Notifikasi (pengumuman masuk)
    MenuItemModel(
      "Notifikasi",
      Icons.notification_add_rounded,
      "/notifications",
    ),

    /// PROFIL
    MenuItemModel("Profil Saya", Icons.person_rounded, "/profile"),
  ];

  // ========================================
  // ⭐ PERMISSION KHUSUS RPP
  // ========================================
  static final Map<String, List<String>> rppPermissions = {
    "admin": ["/admin/rpp", "/rpp/preview", "/rpp/history"],
    "kepsek": [
      "/kepsek/rpp",
      "/kepsek/rpp/review",
      "/rpp/preview",
      "/rpp/history",
    ],
    "guru": [
      "/rpp",
      "/rpp/create",
      "/rpp/edit",
      "/rpp/preview",
      "/rpp/history",
    ],
  };

  // ========================================
  // ⭐ PERMISSION KHUSUS PENGUMUMAN
  // ========================================
  static final Map<String, List<String>> announcementPermissions = {
    "admin": [
      "/announcement",
      "/announcement/create",
      "/announcement/edit",
      "/announcement/detail",
    ],
    "kepsek": [
      "/announcement",
      "/announcement/create",
      "/announcement/edit",
      "/announcement/detail",
    ],
    "guru": [
      "/announcement/detail", // hanya view
    ],
  };
}
