import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterGuruPage extends StatelessWidget {
  const WeeklyRosterGuruPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeeklyRosterRppPage(
      role: "guru",
      title: "Jadwal Mengajar Saya",
    );
  }
}
