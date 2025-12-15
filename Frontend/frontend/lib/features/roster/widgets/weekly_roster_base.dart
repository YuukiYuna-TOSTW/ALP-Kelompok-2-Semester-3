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

  final List<String> dayNames = const [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
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

  List<Map<String, String>> get todaySchedule =>
      weeklySchedule[selectedDay] ?? [];

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: widget.role,
      selectedRoute: "/schedule",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _bigScheduleCard(),
        ),
      ),
    );
  }

  // ======================================================
  // CARD BESAR (HEADER MENTOK + CONTENT)
  // ======================================================
  Widget _bigScheduleCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _daySelector(),
                const SizedBox(height: 20),
                _scheduleList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // HEADER (TANPA BACK BUTTON)
  // ======================================================
  Widget _cardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // DAY SELECTOR
  // ======================================================
  Widget _daySelector() {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dayNames.length,
        itemBuilder: (context, i) {
          final active = i == selectedDay;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active
                      ? AppColors.primary
                      : Colors.grey.withOpacity(.3),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                dayNames[i],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ======================================================
  // LIST JADWAL
  // ======================================================
  Widget _scheduleList() {
    if (todaySchedule.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            "Tidak ada jadwal hari ini",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return Column(children: todaySchedule.map(_scheduleItemCard).toList());
  }

  // ======================================================
  // ITEM JADWAL
  // ======================================================
  Widget _scheduleItemCard(Map<String, String> item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(.15)),
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
          const SizedBox(height: 6),
          Text("Waktu : ${item['start']} - ${item['end']}"),
          if (widget.role != "guru") Text("Guru  : ${item['teacher']}"),
          Text("Kelas : ${item['kelas']}"),
        ],
      ),
    );
  }
}
