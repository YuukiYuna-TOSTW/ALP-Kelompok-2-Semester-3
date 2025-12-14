import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class WeeklyRosterBase extends StatefulWidget {
  final String role;
  final Map<String, dynamic> profileData;

  /// ⭐ DATA JADWAL DIKIRIM DARI PAGE (guru/admin/kepsek)
  final List<Map<String, String>> schedule;

  const WeeklyRosterBase({
    super.key,
    required this.role,
    required this.profileData,
    required this.schedule,
  });

  @override
  State<WeeklyRosterBase> createState() => _WeeklyRosterBaseState();
}

class _WeeklyRosterBaseState extends State<WeeklyRosterBase> {
  int selectedDay = 0;
  late DateTime weekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  final List<String> dayNames = const [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  List<int> get dayDate =>
      List.generate(7, (i) => weekStart.add(Duration(days: i)).day);

  /// ⭐ sekarang BENAR-BENAR pakai data dari luar
  List<Map<String, String>> get todaySchedule => widget.schedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 20),
        _daySelector(),
        const SizedBox(height: 12),
        Expanded(child: _scheduleList()),
      ],
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_month, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Jadwal Mingguan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DAY SELECTOR =================
  Widget _daySelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, i) {
          final active = i == selectedDay;

          return GestureDetector(
            onTap: () => setState(() => selectedDay = i),
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                      color: active ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayDate[i].toString(),
                    style: TextStyle(
                      color: active ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  // ================= LIST =================
  Widget _scheduleList() {
    if (todaySchedule.isEmpty) {
      return const Center(
        child: Text(
          "Tidak Ada Jadwal",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: todaySchedule.length,
      itemBuilder: (context, i) => _scheduleCard(todaySchedule[i]),
    );
  }

  // ================= CARD =================
  Widget _scheduleCard(Map<String, String> item) {
    final bool isGuru = widget.role == "guru";

    final String kelasGuru = (widget.profileData["kelas"] is List)
        ? (widget.profileData["kelas"] as List).join(", ")
        : "-";

    final String kelas = isGuru ? kelasGuru : (item["kelas"] ?? "-");

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item["subject"] ?? "-",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text("Waktu: ${item['start']} - ${item['end']}"),
            if (!isGuru && item["teacher"] != null)
              Text("Guru: ${item['teacher']}"),
            const SizedBox(height: 4),
            Text("Kelas: $kelas"),
          ],
        ),
      ),
    );
  }
}
