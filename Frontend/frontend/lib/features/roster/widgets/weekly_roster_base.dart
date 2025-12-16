import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';
import '../../../core/services/schedule_review_service.dart';

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

  List<Map<String, dynamic>> _allSchedules = [];
  bool _loading = true;

  // ✅ UBAH: ambil dari backend dan filter by hari
  List<Map<String, String>> get todaySchedule {
    if (_allSchedules.isEmpty) return [];

    return _allSchedules
        .where((e) {
          final raw = (e['Tanggal_Mulai'] ?? '').toString();
          if (raw.isEmpty) return false;

          // ambil tanggal saja untuk hindari geser zona waktu
          final dateStr = raw.split('T').first; // YYYY-MM-DD
          final date = DateTime.tryParse(dateStr);
          if (date == null) return false;

          final mappedDay = date.weekday == DateTime.sunday ? 6 : date.weekday - 1;
          debugPrint('raw=$raw date=$date mapped=$mappedDay selected=$selectedDay');

          return mappedDay == selectedDay;
        })
        .map((e) {
          final mulai = (e['Waktu_Mulai'] ?? '00:00:00').toString();
          final selesai = (e['Waktu_Selesai'] ?? '00:00:00').toString();
          return {
            "subject": (e['Nama_Kegiatan'] ?? '-').toString(),
            "start": mulai.length >= 5 ? mulai.substring(0, 5) : '00:00',
            "end": selesai.length >= 5 ? selesai.substring(0, 5) : '00:00',
            "teacher": (e['Penyelenggara'] ?? 'Unknown').toString(),
            "kelas": (e['Tempat'] ?? '-').toString(),
          };
        })
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // ✅ set hari aktif ke hari ini (0=Senin, ..., 6=Minggu)
    final todayIdx = DateTime.now().weekday == 7
        ? 6
        : DateTime.now().weekday - 1;
    selectedDay = todayIdx;

    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _loading = true);
    final data = await ScheduleReviewService.getAllSchedules();

    // 🔍 debug: cek jumlah dan contoh data
    debugPrint('loaded schedules: ${data.length}');
    if (data.isNotEmpty) debugPrint('first: ${data.first}');

    setState(() {
      _allSchedules = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: widget.role,
      selectedRoute: "/schedule",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _bigScheduleCard(),
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
