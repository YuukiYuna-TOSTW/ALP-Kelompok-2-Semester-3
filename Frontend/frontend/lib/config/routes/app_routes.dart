import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ROLE CONTROLLER
import '../../main.dart';

// AUTH
import '../../features/auth/pages/role_preview_page.dart';
import '../../features/auth/widgets/tambah_kegiatan.dart';

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

// KALENDER
import '../../features/calendar/table_calender.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> allRoutes(BuildContext context) {
    return {
      // =======================================================
      // ROLE PREVIEW
      // =======================================================
      "/role-preview": (_) => const RolePreviewPage(),

      // =======================================================
      // DASHBOARD (Dynamic by Role)
      // =======================================================
      "/dashboard": (_) {
        final role = context.read<RoleController>().role;
        return DashboardPage(role: role);
      },

      // =======================================================
      // RPP — GURU
      // =======================================================
      "/rpp": (_) => const RppListPage(),

      "/rpp/create": (_) => const RppFormPage(),

      "/rpp/edit": (context) {
        final args = ModalRoute.of(context)!.settings.arguments;

        if (args is Map) {
          final safeMap = Map<String, dynamic>.from(args);
          return RppEditPage(data: safeMap);
        }

        return const RppEditPage();
      },

      "/rpp/preview": (context) {
        final args = ModalRoute.of(context)!.settings.arguments;

        final data = (args is Map)
            ? Map<String, dynamic>.from(args)
            : <String, dynamic>{};

        return RppPreviewPage(
          mapel: data["mapel"] ?? "",
          kelas: data["kelas"] ?? "",
          bab: data["bab"] ?? "",
          status: data["status"] ?? "",
        );
      },

      "/rpp/history": (context) {
        final args = ModalRoute.of(context)!.settings.arguments;

        final data = (args is Map)
            ? Map<String, dynamic>.from(args)
            : <String, dynamic>{};

        return RppHistoryPage(data: data);
      },

      // =======================================================
      // RPP — KEPSEK / WAKASEK
      // =======================================================
      "/kepsek/rpp": (_) => const RppAllListPage(),

      "/kepsek/rpp/review": (context) {
        final args = ModalRoute.of(context)!.settings.arguments;

        final data = (args is Map)
            ? Map<String, dynamic>.from(args)
            : <String, dynamic>{};

        return RppReviewPage(data: data);
      },

      // =======================================================
      // RPP — ADMIN
      // =======================================================
      "/admin/rpp": (_) => const AdminRppListPage(),

      // =======================================================
      // FITUR LAIN
      // =======================================================
      '/': (_) => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: EventFormCard()),
      ),

      '/calendar': (_) => const CalendarPage(),
    };
  }
}
