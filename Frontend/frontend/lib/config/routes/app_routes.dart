import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ROLE CONTROLLER
import '../../main.dart';

// AUTH — pastikan hanya ini yang punya RolePreviewPage
import '../../features/auth/pages/role_preview_page.dart';

// DASHBOARD
import '../../features/dashboard/dashboard_page.dart';

// RPP — GURU
import '../../features/rpp/pages/guru_rpp_list_pages.dart';
import '../../features/rpp/pages/rpp_form_page.dart';
import '../../features/rpp/pages/rpp_edit_page.dart';
import '../../features/rpp/pages/rpp_preview_page.dart';
import '../../features/rpp/pages/rpp_history_page.dart';

// RPP — KEPSEK
import '../../features/rpp/pages/kepsek_rpp_list_page.dart';
import '../../features/rpp/pages/rpp_review_page.dart';

// RPP — ADMIN
import '../../features/rpp/pages/admin_rpp_list_page.dart';

// PENGUMUMAN
import '../../features/announcement/pages/pengumuman_form_page.dart';
import '../../features/announcement/pages/pengumuman_list_page.dart';
import '../../features/announcement/pages/pengumuman_detail_page.dart';

// KALENDER
import '../../features/calendar/table_calender.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> allRoutes(BuildContext context) {
    return {
      // ========================
      // ROLE PREVIEW
      // ========================
      "/role-preview": (_) => const RolePreviewPage(),

      // ========================
      // DASHBOARD
      // ========================
      "/dashboard": (_) {
        final role = context.read<RoleController>().role;
        return DashboardPage(role: role);
      },

      // ========================
      // RPP — GURU
      // ========================
      "/rpp": (_) => const RppListPage(),

      "/rpp/create": (_) => const RppFormPage(),

      "/rpp/edit": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return RppEditPage(data: data);
      },

      "/rpp/preview": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return RppPreviewPage(
          mapel: data["mapel"] ?? "",
          kelas: data["kelas"] ?? "",
          bab: data["bab"] ?? "",
          status: data["status"] ?? "",
        );
      },

      "/rpp/history": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return RppHistoryPage(data: data);
      },

      // ========================
      // RPP — KEPSEK
      // ========================
      "/kepsek/rpp": (_) => const RppAllListPage(),

      "/kepsek/rpp/review": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return RppReviewPage(data: data);
      },

      // ========================
      // RPP — ADMIN
      // ========================
      "/admin/rpp": (_) => const AdminRppListPage(),

      // ========================
      // PENGUMUMAN — ADMIN & KEPSEK
      // ========================
      "/announcement": (_) {
        final role = context.read<RoleController>().role;
        return PengumumanListPage(role: role);
      },

      "/announcement/create": (_) => const PengumumanFormPage(),

      "/announcement/edit": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return PengumumanFormPage(data: data);
      },

      // ========================
      // PENGUMUMAN — GURU
      // ========================
      "/announcement/detail": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return PengumumanDetailPage(data: data);
      },

      // ========================
      // OTHER ROUTES
      // ========================
      "/": (_) => const Scaffold(body: Center(child: Text("Welcome"))),

      "/calendar": (_) => const CalendarPage(),
    };
  }

  // SAFE MAP HELPER
  static Map<String, dynamic> _safeArgs(dynamic args) {
    if (args is Map) return Map<String, dynamic>.from(args);
    return {};
  }
}
