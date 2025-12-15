import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/rpp_layout.dart';
import '../utils/rpp_exporter.dart';

class AdminRppListPage extends StatefulWidget {
  const AdminRppListPage({super.key});

  @override
  State<AdminRppListPage> createState() => _AdminRppListPageState();
}

class _AdminRppListPageState extends State<AdminRppListPage> {
  // ================= SAMPLE DATA =================
  final List<Map<String, dynamic>> _allRpp = [
    {
      "guru": "Ari Pratama",
      "mapel": "Matematika",
      "kelas": "8A",
      "semester": "Ganjil",
      "bab": "Persamaan Linear",
      "tanggal": "10 Jan 2025",
      "status": "Draft",
    },
    {
      "guru": "Indah Sari",
      "mapel": "Bahasa Indonesia",
      "kelas": "7B",
      "semester": "Genap",
      "bab": "Teks Eksposisi",
      "tanggal": "12 Jan 2025",
      "status": "Menunggu Review",
    },
    {
      "guru": "Rama Putra",
      "mapel": "IPA",
      "kelas": "9A",
      "semester": "Ganjil",
      "bab": "Sistem Pernafasan",
      "tanggal": "5 Jan 2025",
      "status": "Disetujui",
    },
    {
      "guru": "Sinta Dewi",
      "mapel": "IPS",
      "kelas": "7A",
      "semester": "Genap",
      "bab": "Interaksi Sosial",
      "tanggal": "9 Jan 2025",
      "status": "Revisi",
    },
  ];

  List<Map<String, dynamic>> filtered = [];

  String search = "";
  String filterStatus = "Semua";
  String filterGuru = "Semua";

  @override
  void initState() {
    super.initState();
    filtered = [..._allRpp];
  }

  // ================= FILTER =================
  void _applyFilters() {
    final q = search.toLowerCase();

    setState(() {
      filtered = _allRpp.where((item) {
        final matchSearch =
            item["mapel"].toLowerCase().contains(q) ||
            item["kelas"].toLowerCase().contains(q) ||
            item["bab"].toLowerCase().contains(q);

        final matchStatus =
            filterStatus == "Semua" || item["status"] == filterStatus;

        final matchGuru = filterGuru == "Semua" || item["guru"] == filterGuru;

        return matchSearch && matchStatus && matchGuru;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "admin",
      selectedRoute: "/admin/rpp",
      content: _buildContent(),
    );
  }

  // ================= MAIN CARD =================
  Widget _buildContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _cardHeader(),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    _filterBar(),
                    const SizedBox(height: 20),
                    _buildTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CARD HEADER =================
  Widget _cardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Manajemen RPP Guru",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => exportRppToPdf({"all": filtered}),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text("Export Semua"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(.15),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER BAR =================
  Widget _filterBar() {
    final List<String> guruList = [
      "Semua",
      ..._allRpp.map((e) => e["guru"] as String).toSet(),
    ];

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari mapel, kelas, atau bab...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) {
              search = v;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 14),
        _dropdown("Guru", filterGuru, guruList, (v) {
          filterGuru = v!;
          _applyFilters();
        }),
        const SizedBox(width: 12),
        _dropdown(
          "Status",
          filterStatus,
          const ["Semua", "Draft", "Menunggu Review", "Revisi", "Disetujui"],
          (v) {
            filterStatus = v!;
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ================= TABLE =================
  Widget _buildTable() {
    return DataTable(
      columnSpacing: 20,
      headingRowHeight: 48,
      dataRowHeight: 56,
      headingRowColor: MaterialStateProperty.all(AppColors.primary),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: Text("Guru")),
        DataColumn(label: Text("Mapel")),
        DataColumn(label: Text("Kelas")),
        DataColumn(label: Text("Semester")),
        DataColumn(label: Text("Tanggal")),
        DataColumn(label: Center(child: Text("Status"))),
        DataColumn(label: Center(child: Text("Aksi"))),
      ],
      rows: filtered.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(item["guru"])),
            DataCell(Text(item["mapel"])),
            DataCell(Text(item["kelas"])),
            DataCell(Text(item["semester"])),
            DataCell(Text(item["tanggal"])),
            DataCell(_statusChip(item["status"])),
            DataCell(_actionMenu(item)),
          ],
        );
      }).toList(),
    );
  }

  // ================= STATUS CHIP =================
  Widget _statusChip(String status) {
    late Color bg;
    late Color text;

    switch (status) {
      case "Draft":
        bg = Colors.grey.withOpacity(.15);
        text = Colors.grey;
        break;
      case "Menunggu Review":
        bg = Colors.blue.withOpacity(.15);
        text = Colors.blue;
        break;
      case "Revisi":
        bg = Colors.orange.withOpacity(.15);
        text = Colors.orange;
        break;
      case "Disetujui":
        bg = Colors.green.withOpacity(.15);
        text = Colors.green;
        break;
      default:
        bg = Colors.grey.withOpacity(.15);
        text = Colors.grey;
    }

    return Center(
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ),
      ),
    );
  }

  // ================= ACTION MENU =================
  Widget _actionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (v) {
        if (v == 'view') {
          Navigator.pushNamed(context, "/rpp/preview", arguments: item);
        } else if (v == 'history') {
          Navigator.pushNamed(context, "/rpp/history", arguments: item);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 18),
              SizedBox(width: 8),
              Text("Lihat RPP"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'history',
          child: Row(
            children: [
              Icon(Icons.history, size: 18),
              SizedBox(width: 8),
              Text("Riwayat"),
            ],
          ),
        ),
      ],
    );
  }
}
