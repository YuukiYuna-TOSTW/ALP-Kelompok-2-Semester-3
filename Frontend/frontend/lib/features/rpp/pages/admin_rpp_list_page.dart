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
  // ================================
  // Dummy Data
  // ================================
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

  // ================================
  // FILTERING
  // ================================
  void applyFilters() {
    setState(() {
      final q = search.toLowerCase();

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

  // ================================
  // CONTENT WRAPPER
  // ================================
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(),
        const SizedBox(height: 20),
        _filterRow(),
        const SizedBox(height: 20),
        _buildTable(),
      ],
    );
  }

  // ================================
  // HEADER
  // ================================
  Widget _pageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Manajemen RPP Guru (Admin)",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        // Export semua RPP
        ElevatedButton.icon(
          onPressed: () {
            exportRppToPdf({"all": _allRpp});
          },
          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: const Text("Export Semua RPP"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  // ================================
  // FILTER BAR
  // ================================
  Widget _filterRow() {
    final guruList = ["Semua", ..._allRpp.map((e) => e["guru"]).toSet()];

    return Row(
      children: [
        // Search Field
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari mapel, kelas, atau bab...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (v) {
              search = v;
              applyFilters();
            },
          ),
        ),

        const SizedBox(width: 14),

        // Filter Guru
        DropdownButton<String>(
          value: filterGuru,
          items: guruList.map((g) {
            final str = g.toString();
            return DropdownMenuItem<String>(value: str, child: Text(str));
          }).toList(),
          onChanged: (v) {
            filterGuru = v!;
            applyFilters();
          },
        ),

        const SizedBox(width: 14),

        // Filter Status
        DropdownButton<String>(
          value: filterStatus,
          items: ["Semua", "Draft", "Menunggu Review", "Revisi", "Disetujui"]
              .map((s) {
                return DropdownMenuItem<String>(value: s, child: Text(s));
              })
              .toList(),
          onChanged: (v) {
            filterStatus = v!;
            applyFilters();
          },
        ),
      ],
    );
  }

  // ================================
  // DATA TABLE
  // ================================
  Widget _buildTable() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.primary),
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
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Aksi")),
        ],
        rows: filtered.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item["guru"])),
              DataCell(Text(item["mapel"])),
              DataCell(Text(item["kelas"])),
              DataCell(Text(item["semester"])),
              DataCell(Text(item["tanggal"])),
              DataCell(statusChip(item["status"])),
              DataCell(_actionButtons(item)),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ================================
  // STATUS CHIP
  // ================================
  Widget statusChip(String status) {
    Color color;

    switch (status) {
      case "Draft":
        color = Colors.grey;
        break;
      case "Menunggu Review":
        color = Colors.blue;
        break;
      case "Revisi":
        color = Colors.orange;
        break;
      case "Disetujui":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ================================
  // ACTION BUTTONS (Admin Read Only)
  // ================================
  Widget _actionButtons(Map<String, dynamic> item) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, color: AppColors.primary),
          onPressed: () {
            Navigator.pushNamed(context, "/rpp/preview", arguments: item);
          },
        ),
        IconButton(
          icon: const Icon(Icons.history, color: Colors.orange),
          onPressed: () {
            Navigator.pushNamed(context, "/rpp/history", arguments: item);
          },
        ),
      ],
    );
  }
}
