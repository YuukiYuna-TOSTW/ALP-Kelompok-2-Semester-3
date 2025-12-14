import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ROLE CONTROLLER
import '../../main.dart';

// AUTH
import '../../features/auth/pages/role_preview_page.dart';
import '../../features/auth/widgets/about.screen.dart';

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

// NOTIFICATIONS
import '../../features/notifications/notification_page.dart';
import '../../features/notifications/notification_detail_page.dart';

// JADWAL (PER ROLE)
import '../../features/roster/pages/weekly_roster_guru_page.dart';
import '../../features/roster/pages/weekly_roster_admin_page.dart';
import '../../features/roster/pages/weekly_roster_kepsek_page.dart';

// CHATBOT
import '../../features/chatbot/pages/chatbot_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> allRoutes(BuildContext context) {
    return {
      // ============================================================
      // AUTH
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
      // NOTIFICATIONS
      // ============================================================
      "/notifications": (_) {
        final role = context.read<RoleController>().role;
        return NotificationPage(role: role);
      },
      "/notifications/detail": (ctx) {
        final role = context.read<RoleController>().role;
        final data = _safeArgs(ModalRoute.of(ctx)!.settings.arguments);
        return NotificationDetailPage(role: role, data: data);
      },

      // ============================================================
      // PROFILE
      // ============================================================
      "/profile": (_) {
        final role = context.read<RoleController>().role;
        return ProfilePage(
          role: role,
          data: {
            "nama": "Nama Pengguna",
            "kelas": ["7A", "8B", "9C"],
          },
        );
      },
      "/profile/edit": (ctx) {
        final role = context.read<RoleController>().role;
        return EditProfilePage(
          role: role,
          data: _safeArgs(ModalRoute.of(ctx)!.settings.arguments),
        );
      },
      "/profile/password": (_) => const ChangePasswordPage(),

      // ============================================================
      // 📅 JADWAL — SATU ROUTE, PER ROLE (FIXED)
      // ============================================================
      "/schedule": (_) {
        final role = context.read<RoleController>().role;

        switch (role) {
          case "guru":
            return const WeeklyRosterGuruPage();
          case "admin":
            return const WeeklyRosterAdminPage();
          case "kepsek":
          case "wakasek":
            return const WeeklyRosterKepsekPage();
          default:
            return const Scaffold(
              body: Center(child: Text("Role tidak dikenali")),
            );
        }
      },

      // ============================================================
      // CHATBOT
      // ============================================================
      "/assistant": (_) => const ChatbotPage(),

      // ============================================================
      // MISC
      // ============================================================
      "/calendar": (_) => const CalendarPage(),
      "/about": (_) => const AboutScreen(),
      "/": (_) => const Scaffold(body: Center(child: Text("Welcome"))),
    };
  }

  // ============================================================
  // SAFE ARGS
  // ============================================================
  static Map<String, dynamic> _safeArgs(dynamic args) {
    if (args is Map) return Map<String, dynamic>.from(args);
    return {};
  }
}
