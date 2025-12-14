import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterAdminPage extends StatelessWidget {
  const WeeklyRosterAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeeklyRosterRppPage(
      role: "admin",
      title: "Manajemen Jadwal Sekolah",
    );
  }
}
