import 'package:flutter/material.dart';
import 'layout/layout_template.dart';
import 'widgets/admin_dashboard.dart';
import 'widgets/guru_dashboard.dart';
import 'widgets/kepsek_dashboard.dart';
import 'right_panels/guru_right_panels.dart';
import 'right_panels/kepsek_right_panel.dart';

class DashboardPage extends StatelessWidget {
  final String role;

  const DashboardPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      role: role,
      selectedRoute: "/dashboard",
      content: _buildContent(role),
      rightPanel: _buildRightPanel(role),
    );
  }

  // ============================
  // MAIN CONTENT (Tengah)
  // ============================
  Widget _buildContent(String role) {
    switch (role) {
      case "admin":
        return const AdminDashboardContent();
      case "guru":
        return const GuruDashboardContent();
      case "kepsek":
      case "wakasek":
        return const KepsekDashboardContent();
      default:
        return const Center(child: Text("Role tidak dikenali"));
    }
  }

  // ============================
  // RIGHT PANEL (Aktivitas + Kalender)
  // ============================
  Widget _buildRightPanel(String role) {
    switch (role) {
      // case "admin":
      //   return const AdminRightPanel();

      case "guru":
        return const GuruRightPanel();

      case "kepsek":
      case "wakasek":
        return const KepsekRightPanel();

      default:
        return const SizedBox();
    }
  }
}
