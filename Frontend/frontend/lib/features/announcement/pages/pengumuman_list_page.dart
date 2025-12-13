import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class PengumumanListPage extends StatefulWidget {
  final String role; // admin / kepsek / wakasek

  const PengumumanListPage({super.key, required this.role});

  @override
  State<PengumumanListPage> createState() => _PengumumanListPageState();
}

class _PengumumanListPageState extends State<PengumumanListPage> {
  final List<Map<String, dynamic>> _allAnnouncements = [
    {
      "judul": "Rapat Guru Mingguan",
      "oleh": "Kepala Sekolah",
      "target": "Semua Guru",
      "status": "Terbit",
      "tanggal": "10 Feb 2025",
      "lampiran": true,
    },
    {
      "judul": "Pembagian Jadwal Pelajaran",
      "oleh": "Admin",
      "target": "Wali Kelas",
      "status": "Draft",
      "tanggal": "-",
      "lampiran": false,
    },
    {
      "judul": "Edaran Hari Besar Nasional",
      "oleh": "Wakasek",
      "target": "Semua Guru",
      "status": "Selesai",
      "tanggal": "1 Feb 2025",
      "lampiran": true,
    },
  ];

  List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = [..._allAnnouncements];
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      selectedRoute: "/announcement",
      role: widget.role,
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: _buildCard(),
        ),
      ),
    );
  }

  // ============================================================
  // CARD UTAMA
  // ============================================================
  Widget _buildCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _header(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Text(
        "Manajemen Pengumuman",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH + BUTTON TAMBAH
  // ============================================================
  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari judul atau pembuat...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) {
              setState(() {
                filtered = _allAnnouncements
                    .where(
                      (e) =>
                          e["judul"].toLowerCase().contains(
                            val.toLowerCase(),
                          ) ||
                          e["oleh"].toLowerCase().contains(val.toLowerCase()),
                    )
                    .toList();
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/announcement/create"),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Buat Pengumuman"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABLE
  // ============================================================
  Widget _buildTable() {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(AppColors.primary),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: Text("Judul")),
        DataColumn(label: Text("Dibuat Oleh")),
        DataColumn(label: Text("Target")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("Publikasi")),
        DataColumn(label: Text("Lampiran")),
        DataColumn(label: Text("Aksi")),
      ],
      rows: filtered.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(item["judul"])),
            DataCell(Text(item["oleh"])),
            DataCell(Text(item["target"])),
            DataCell(_statusChip(item["status"])),
            DataCell(Text(item["tanggal"])),
            DataCell(
              item["lampiran"]
                  ? const Icon(Icons.attach_file, color: AppColors.primary)
                  : const Icon(Icons.close, color: Colors.grey),
            ),
            DataCell(_aksi(item)),
          ],
        );
      }).toList(),
    );
  }

  // ============================================================
  // STATUS CHIP
  // ============================================================
  Widget _statusChip(String status) {
    Color color = Colors.grey;

    switch (status) {
      case "Draft":
        color = Colors.orange;
        break;
      case "Terbit":
        color = Colors.green;
        break;
      case "Selesai":
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ============================================================
  // AKSI TABLE
  // ============================================================
  Widget _aksi(Map item) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, color: AppColors.primary),
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/announcement/detail",
              arguments: item,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () {
            Navigator.pushNamed(context, "/announcement/edit", arguments: item);
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.blue),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ],
    );
  }
}
