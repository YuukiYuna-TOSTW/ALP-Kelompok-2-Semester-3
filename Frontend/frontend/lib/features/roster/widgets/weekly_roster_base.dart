import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class WeeklyRosterRppPage extends StatefulWidget {
  final String role;
  final String title;

  const WeeklyRosterRppPage({
    super.key,
    required this.role,
    required this.title,
  });

  @override
  State<WeeklyRosterRppPage> createState() => _WeeklyRosterRppPageState();
}

class _WeeklyRosterRppPageState extends State<WeeklyRosterRppPage> {
  int selectedDay = 0;
  late DateTime weekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  final List<String> dayNames = const [
    "Sen",
    "Sel",
    "Rab",
    "Kam",
    "Jum",
    "Sab",
    "Min",
  ];

  final Map<int, List<Map<String, String>>> weeklySchedule = {
    0: [
      {
        "subject": "Biologi",
        "start": "09:10",
        "end": "10:00",
        "teacher": "Pak Budi",
        "kelas": "9A",
      },
    ],
    1: [
      {
        "subject": "Matematika",
        "start": "08:00",
        "end": "09:30",
        "teacher": "Bu Sinta",
        "kelas": "8B",
      },
    ],
    3: [
      {
        "subject": "IPA",
        "start": "10:00",
        "end": "11:30",
        "teacher": "Pak Amir",
        "kelas": "9C",
      },
    ],
  };

  List<int> get dayDate =>
      List.generate(7, (i) => weekStart.add(Duration(days: i)).day);

  List<Map<String, String>> get todaySchedule =>
      weeklySchedule[selectedDay] ?? [];

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: widget.role,
      selectedRoute: "/schedule",
      content: _content(),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),
          _daySelector(),
          const SizedBox(height: 20),
          Expanded(child: _scheduleList()),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _daySelector() {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, i) {
          final active = i == selectedDay;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = i),
            child: Container(
              width: 72,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : Colors.grey.withOpacity(.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNames[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayDate[i].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _scheduleList() {
    if (todaySchedule.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada jadwal hari ini",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView(children: todaySchedule.map(_scheduleCard).toList());
  }

  Widget _scheduleCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["subject"] ?? "-",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text("Waktu: ${item['start']} - ${item['end']}"),
          if (widget.role != "guru") Text("Guru: ${item['teacher']}"),
          Text("Kelas: ${item['kelas']}"),
        ],
      ),
    );
  }
}
