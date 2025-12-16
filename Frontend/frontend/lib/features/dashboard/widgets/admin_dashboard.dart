import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../core/services/admin_statistik_service.dart';
import '../components/stat_card.dart';
import '../components/quick_action_button.dart';

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  late Future<Map<String, dynamic>> statisticsFuture;

  @override
  void initState() {
    super.initState();
    statisticsFuture = AdminStatistikService.getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // ⭐ STATISTIK SISTEM
        // =====================================================
        const Text(
          "Statistik Sistem",
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
            // Debug logging
            print('📊 Admin Stats - State: ${snapshot.connectionState}');
            print('📊 Admin Stats - Has Data: ${snapshot.hasData}');
            print('📊 Admin Stats - Data: ${snapshot.data}');
            if (snapshot.hasError) {
              print('❌ Admin Stats - Error: ${snapshot.error}');
            }

            String totalGuru = "48";
            String totalKelas = "24";
            String mataPelajaran = "16";
            String totalJadwal = "192";
            String totalRpp = "73";

            if (snapshot.connectionState == ConnectionState.done &&
                (snapshot.data?['success'] ?? false)) {
              final data = snapshot.data?['data'] ?? {};
              totalGuru = (data['total_guru'] ?? 48).toString();
              totalKelas = (data['total_kelas'] ?? 24).toString();
              mataPelajaran = (data['mata_pelajaran'] ?? 16).toString();
              totalJadwal = (data['total_jadwal'] ?? 192).toString();
              totalRpp = (data['total_rpp'] ?? 73).toString();

              print(
                '✅ Admin Stats - Updated values: Guru=$totalGuru, Kelas=$totalKelas, Mapel=$mataPelajaran, Jadwal=$totalJadwal, RPP=$totalRpp',
              );
            }

            return Column(
              children: [
                Row(
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
                        icon: Icons.school_rounded,
                        value: totalKelas,
                        title: "Total Kelas",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: StatCard(
                        icon: Icons.book_rounded,
                        value: mataPelajaran,
                        title: "Mata Pelajaran",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.calendar_month_rounded,
                        value: totalJadwal,
                        title: "Total Jadwal",
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: StatCard(
                        icon: Icons.menu_book_rounded,
                        value: totalRpp,
                        title: "Total RPP",
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 32),

        // =====================================================
        // ⭐ AKSI CEPAT (SAMA DENGAN KEPSEK)
        // =====================================================
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
}
