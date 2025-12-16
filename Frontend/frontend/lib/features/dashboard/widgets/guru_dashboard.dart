import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';
import '../components/schedule_card.dart';
import '../../../core/services/schedule_review_service.dart'; // ✅ TAMBAH import

class GuruDashboardContent extends StatefulWidget {
  const GuruDashboardContent({super.key});

  @override
  State<GuruDashboardContent> createState() => _GuruDashboardContentState();
}

class _GuruDashboardContentState extends State<GuruDashboardContent> {
  List<Map<String, dynamic>> _todaySchedules = [];
  bool _loadingSchedules = true;

  @override
  void initState() {
    super.initState();
    _loadTodaySchedules();
  }

  Future<void> _loadTodaySchedules() async {
    setState(() => _loadingSchedules = true);
    final allSchedules = await ScheduleReviewService.getAllSchedules();
    
    // ✅ Filter hanya jadwal hari ini
    final today = DateTime.now();
    final todayStr = '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final todayOnly = allSchedules
        .where((e) => (e['Tanggal_Mulai'] ?? '').toString().startsWith(todayStr))
        .toList();

    setState(() {
      _todaySchedules = todayOnly;
      _loadingSchedules = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ===============================
          // ⭐ JADWAL MENGAJAR HARI INI
          // ===============================
          const Text(
            "Jadwal Mengajar Hari Ini",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          _loadingSchedules
              ? const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                )
              : _todaySchedules.isEmpty
                  ? const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          'Tidak ada jadwal hari ini',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _todaySchedules
                              .map((schedule) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: TeachingScheduleCard(
                                    subject: schedule['Nama_Kegiatan'] ?? '-',
                                    time: '${schedule['Waktu_Mulai'] ?? '00:00'} – ${schedule['Waktu_Selesai'] ?? '00:00'}',
                                    className: schedule['Tempat'] ?? '-',
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),

          const SizedBox(height: 28),

          // ===============================
          // ⭐ STATISTIK MINGGUAN
          // ===============================
          const Text(
            "Statistik Mingguan",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: const [
              Expanded(
                child: StatCard(
                  icon: Icons.menu_book_rounded,
                  value: "6",
                  title: "RPP Pending",
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: StatCard(
                  icon: Icons.class_rounded,
                  value: "3",
                  title: "Total Kelas",
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: StatCard(
                  icon: Icons.schedule_rounded,
                  value: "12",
                  title: "Jam Mengajar",
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ===============================
          // ⭐ AKSI CEPAT
          // ===============================
          const Text(
            "Aksi Cepat",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.add_chart_rounded,
                  label: "Buat RPP",
                  onTap: () => Navigator.pushNamed(context, "/rpp/create"),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.edit_document,
                  label: "Revisi RPP",
                  onTap: () => Navigator.pushNamed(context, "/rpp"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
