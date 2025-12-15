import 'package:flutter/material.dart';
import 'package:frontend/core/services/kepsek_statistiksekolah_dashboard_service.dart';
import 'package:frontend/core/services/kepsek_rpp_dashboard_service.dart';
import '../../../config/theme/colors.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';
import '../components/rpp_review_card.dart';

class KepsekDashboardContent extends StatefulWidget {
  const KepsekDashboardContent({super.key});

  @override
  State<KepsekDashboardContent> createState() => _KepsekDashboardContentState();
}

class _KepsekDashboardContentState extends State<KepsekDashboardContent> {
  late Future<Map<String, dynamic>> rppDataFuture;
  late Future<Map<String, dynamic>> statisticsFuture;

  @override
  void initState() {
    super.initState();
    rppDataFuture = KepsekRppDashboardService.getRppPendingReview();
    statisticsFuture = KepsekStatistikSekolahDashboardService.getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // ===============================
        // ⭐ RPP PENDING REVIEW
        // ===============================
        const Text(
          "RPP Pending Review",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        FutureBuilder<Map<String, dynamic>>(
          future: rppDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError || !(snapshot.data?['success'] ?? false)) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.data?['message'] ?? 'Gagal memuat data',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final rppList = (snapshot.data?['data'] ?? []) as List;

            if (rppList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Tidak ada RPP yang menunggu review'),
              );
            }

            return Column(
              children: [
                for (int i = 0; i < rppList.length; i++) ...[
                  RppReviewCard(
                    subject: rppList[i]['Nama_Mata_Pelajaran'] ?? 'Mata Pelajaran',
                    className: rppList[i]['Kelas'] ?? 'Kelas',
                    teacher: rppList[i]['Guru_Nama'] ?? 'Guru',
                    time: _getTimeAgo(rppList[i]['created_at']),
                    onReview: () {
                      Navigator.pushNamed(
                        context,
                        "/kepsek/rpp/review",
                        arguments: {
                          "mapel": rppList[i]['Nama_Mata_Pelajaran'] ?? '',
                          "kelas": rppList[i]['Kelas'] ?? '',
                          "guru": rppList[i]['Guru_Nama'] ?? '',
                          "rpp_id": rppList[i]['RPP_ID'],
                        },
                      );
                    },
                  ),
                  if (i < rppList.length - 1) const SizedBox(height: 10),
                ]
              ],
            );
          },
        ),

        const SizedBox(height: 28),

        // ===============================
        // ⭐ STATISTIK SEKOLAH
        // ===============================
        const Text(
          "Statistik Sekolah",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        FutureBuilder<Map<String, dynamic>>(
          future: statisticsFuture,
          builder: (context, snapshot) {
            String totalGuru = "0";
            String rppPending = "0";
            String totalKelas = "0";

            if (snapshot.connectionState == ConnectionState.done &&
                (snapshot.data?['success'] ?? false)) {
              final data = snapshot.data?['data'] ?? {};
              totalGuru = (data['total_guru'] ?? 0).toString();
              rppPending = (data['rpp_pending'] ?? 0).toString();
              totalKelas = (data['total_kelas'] ?? 0).toString();
            }

            return Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.person_rounded,
                    value: totalGuru,
                    title: "Total Guru",
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: StatCard(
                    icon: Icons.menu_book_rounded,
                    value: rppPending,
                    title: "RPP Pending",
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: StatCard(
                    icon: Icons.school_rounded,
                    value: totalKelas,
                    title: "Total Kelas",
                  ),
                ),
              ],
            );
          },
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
                icon: Icons.event_available_rounded,
                label: "Buat Kegiatan",
                onTap: () {
                  Navigator.pushNamed(context, "/calendar");
                },
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: QuickActionButton(
                icon: Icons.calendar_today_rounded,
                label: "Export Jadwal",
                onTap: () {
                  Navigator.pushNamed(context, "/schedule/export");
                },
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: QuickActionButton(
                icon: Icons.campaign_rounded,
                label: "Buat Pengumuman",
                onTap: () {
                  Navigator.pushNamed(context, "/announcement/create");
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  String _getTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Baru saja';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return dateString;
    } catch (_) {
      return dateString;
    }
  }
}
