import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterKepsekPage extends StatelessWidget {
  const WeeklyRosterKepsekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WeeklyRosterBase(
      role: "kepsek",
      profileData: const {},
      schedule: const [
        {
          "subject": "Biologi",
          "start": "09:10",
          "end": "10:00",
          "teacher": "Pak Budi",
          "kelas": "9A",
        },
      ],
    );
  }
}
