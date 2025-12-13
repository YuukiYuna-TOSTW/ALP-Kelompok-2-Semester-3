import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ROLE CONTROLLER
import '../../main.dart';

// AUTH
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

// PROFILE
import '../../features/profile/pages/profile_page.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/change_password_page.dart';

// KALENDER
import '../../features/calendar/table_calender.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> allRoutes(BuildContext context) {
    return {
      // ============================================================
      // ROLE PREVIEW
      // ============================================================
      "/role-preview": (_) => const RolePreviewPage(),

      // ============================================================
      // DASHBOARD
      // ============================================================
      "/dashboard": (_) {
        final role = context.read<RoleController>().role;
        return DashboardPage(role: role);
      },

      // ============================================================
      // RPP — GURU
      // ============================================================
      "/rpp": (_) => const RppListPage(),
      "/rpp/create": (_) => const RppFormPage(),

      "/rpp/edit": (ctx) =>
          RppEditPage(data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments)),

      "/rpp/preview": (ctx) {
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return RppPreviewPage(
          mapel: data["mapel"] ?? "",
          kelas: data["kelas"] ?? "",
          bab: data["bab"] ?? "",
          status: data["status"] ?? "",
        );
      },

      "/rpp/history": (ctx) => RppHistoryPage(
        data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments),
      ),

      // ============================================================
      // RPP — KEPSEK
      // ============================================================
      "/kepsek/rpp": (_) => const RppAllListPage(),

      "/kepsek/rpp/review": (ctx) => RppReviewPage(
        data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments),
      ),

      // ============================================================
      // RPP — ADMIN
      // ============================================================
      "/admin/rpp": (_) => const AdminRppListPage(),

      // ============================================================
      // PENGUMUMAN
      // ============================================================
      "/announcement": (_) {
        final role = context.read<RoleController>().role;
        return PengumumanListPage(role: role);
      },

      "/announcement/create": (_) => const PengumumanFormPage(),

      "/announcement/edit": (ctx) => PengumumanFormPage(
        data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments),
      ),

      "/announcement/detail": (ctx) => PengumumanDetailPage(
        data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments),
      ),

      // ============================================================
      // PROFILE
      // ============================================================
      "/profile": (_) {
        final role = context.read<RoleController>().role;

        Map<String, dynamic> data = {
          "nama": "Nama Pengguna",
          "nip": "1234567",
          "email": "email@sekolah.id",
          "hp": "08123456789",
          "foto": "https://cdn-icons-png.flaticon.com/512/149/149071.png",
          "jabatan": role == "kepsek" ? "Kepala Sekolah" : "Guru",
          "tahun_menjabat": "2022",
          "mapel": "Matematika",
          "kelas": ["7A", "8B", "9C"],
          "alamat": "",
          "gender": "Laki-laki",
        };

        return ProfilePage(role: role, data: data);
      },

      "/profile/edit": (ctx) {
        final role = context.read<RoleController>().role;
        final rawArgs = ModalRoute.of(ctx)!.settings.arguments;

        final Map<String, dynamic> data = (rawArgs is Map)
            ? Map<String, dynamic>.from(rawArgs)
            : {};

        return EditProfilePage(role: role, data: data);
      },

      "/profile/password": (_) => const ChangePasswordPage(),

      // ============================================================
      // OTHER ROUTES
      // ============================================================
      "/": (_) => const Scaffold(body: Center(child: Text("Welcome"))),
      "/calendar": (_) => const CalendarPage(),
    };
  }

  // ============================================================
  // SAFE MAP HELPER — FIX Map<dynamic,dynamic> → Map<String,dynamic>
  // ============================================================
  static Map<String, dynamic> _safeArgs(dynamic args) {
    if (args is Map) {
      return Map<String, dynamic>.from(args);
    }
    return {};
  }
}
