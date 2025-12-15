import 'package:flutter/material.dart';
import '../../features/dashboard/models/menu_item_model.dart';

class RoleMenuConfig {
  // ============================================================
  // 🔑 GET MENU BY ROLE
  // ============================================================
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

  // ============================================================
  // ⭐ ADMIN MENU
  // ============================================================
  static final List<MenuItemModel> adminMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),

    // 👥 MANAJEMEN PENGGUNA (BARU)
    MenuItemModel(
      "Manajemen Data",
      Icons.manage_accounts_rounded,
      "/admin/users",
    ),

    // 📅 Jadwal Sekolah
    MenuItemModel("Jadwal Sekolah", Icons.calendar_month_rounded, "/schedule"),

    // 📘 RPP Guru
    MenuItemModel("RPP Guru", Icons.menu_book_rounded, "/admin/rpp"),

    // 🔔 Notifikasi
    MenuItemModel("Notifikasi", Icons.notifications_rounded, "/notifications"),
  ];

  // ============================================================
  // ⭐ KEPALA SEKOLAH / WAKASEK
  // ============================================================
  static final List<MenuItemModel> kepsekMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),

    // 📘 Review RPP
    MenuItemModel("Review RPP Guru", Icons.fact_check_rounded, "/kepsek/rpp"),

    // 📅 Jadwal Sekolah
    MenuItemModel("Jadwal Sekolah", Icons.calendar_today_rounded, "/schedule"),

    // 🔔 Notifikasi
    MenuItemModel("Notifikasi", Icons.notifications_rounded, "/notifications"),
  ];

  // ============================================================
  // 🔐 PERMISSION — ADMIN USERS
  // ============================================================
  static final Map<String, List<String>> userPermissions = {
    "admin": ["/admin/users", "/admin/users/add", "/admin/users/edit"],
  };

  // ============================================================
  // ⭐ GURU MENU
  // ============================================================
  static final List<MenuItemModel> guruMenu = [
    MenuItemModel("Dashboard", Icons.dashboard_rounded, "/dashboard"),

    // 📅 Jadwal Mengajar
    MenuItemModel("Jadwal", Icons.calendar_today_rounded, "/schedule"),

    // 📘 RPP Saya
    MenuItemModel("RPP Saya", Icons.menu_book_rounded, "/rpp"),

    // 🔔 Notifikasi
    MenuItemModel("Notifikasi", Icons.notifications_rounded, "/notifications"),
  ];

  // ============================================================
  // 🔐 PERMISSION — JADWAL (⭐ INI YANG PENTING)
  // ============================================================
  static final Map<String, List<String>> schedulePermissions = {
    "admin": ["/schedule"],
    "kepsek": ["/schedule"],
    "wakasek": ["/schedule"],
    "guru": ["/schedule"],
  };

  // ============================================================
  // 🔐 PERMISSION — RPP
  // ============================================================
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

  // ============================================================
  // 🔐 PERMISSION — PENGUMUMAN
  // ============================================================
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
    "guru": ["/announcement/detail"],
  };
}
