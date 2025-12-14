import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterAdminPage extends StatelessWidget {
  const WeeklyRosterAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WeeklyRosterBase(
      role: "admin",
      profileData: const {},
      schedule: const [
        {
          "subject": "Bahasa Indonesia",
          "start": "08:20",
          "end": "09:10",
          "teacher": "Ibu Siti",
          "kelas": "7B",
        },
      ],
    );
  }
}
