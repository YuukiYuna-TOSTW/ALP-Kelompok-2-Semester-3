import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterKepsekPage extends StatelessWidget {
  const WeeklyRosterKepsekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeeklyRosterRppPage(
      role: "kepsek",
      title: "Jadwal Pelajaran Sekolah",
    );
  }
}
