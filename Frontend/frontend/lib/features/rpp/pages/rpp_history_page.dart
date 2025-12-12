import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/rpp_layout.dart';

class RppHistoryPage extends StatelessWidget {
  final Map? data;

  const RppHistoryPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _buildCard(context),
        ),
      ),
    );
  }

  // ============================================================
  // CARD BESAR DENGAN HEADER
  // ============================================================
  Widget _buildCard(BuildContext context) {
    // Tentukan judul berdasarkan data
    final title = data?["mapel"] != null
        ? "Riwayat RPP • ${data!["mapel"]} (${data!["kelas"]})"
        : "Riwayat RPP";

    final history = [
      {
        "tanggal": "10 Jan 2025",
        "aksi": "Dibuat",
        "oleh": "Guru",
        "catatan": "-",
      },
      {
        "tanggal": "12 Jan 2025",
        "aksi": "Diajukan ke Kepsek",
        "oleh": "Guru",
        "catatan": "Menunggu review",
      },
      {
        "tanggal": "13 Jan 2025",
        "aksi": "Revisi Diminta",
        "oleh": "Kepsek",
        "catatan": "Tujuan pembelajaran perlu diperjelas",
      },
      {
        "tanggal": "14 Jan 2025",
        "aksi": "Diperbaiki",
        "oleh": "Guru",
        "catatan": "Sudah menyesuaikan permintaan revisi",
      },
    ];

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER BIRU =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ================= BODY / RIWAYAT =================
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: history.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tanggal
                      SizedBox(
                        width: 120,
                        child: Text(
                          item["tanggal"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // Detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["aksi"]!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Oleh: ${item["oleh"]}",
                              style: const TextStyle(fontSize: 13),
                            ),

                            if (item["catatan"] != "-")
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Catatan: ${item["catatan"]}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
