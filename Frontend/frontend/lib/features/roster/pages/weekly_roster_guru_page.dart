import 'package:flutter/material.dart';
import '../widgets/weekly_roster_base.dart';

class WeeklyRosterGuruPage extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const WeeklyRosterGuruPage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return WeeklyRosterBase(
      role: "guru",
      profileData: profileData,
      schedule: const [
        {
          "subject": "Matematika",
          "start": "07:30",
          "end": "08:20",
          "kelas": "7A",
        },
      ],
    );
  }
}
