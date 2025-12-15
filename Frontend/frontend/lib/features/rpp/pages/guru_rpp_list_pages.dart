import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../layout/rpp_layout.dart';
import '../utils/rpp_exporter.dart';

class RppListPage extends StatefulWidget {
  const RppListPage({super.key});

  @override
  State<RppListPage> createState() => _RppListPageState();
}

class _RppListPageState extends State<RppListPage> {
  final List<Map<String, dynamic>> _allRpp = [
    {
      "mapel": "Matematika",
      "kelas": "8A",
      "bab": "Persamaan Linear",
      "semester": "Ganjil",
      "tanggalStr": "10 Jan 2025",
      "tanggal": DateTime(2025, 1, 10),
      "status": "Draft",
    },
    {
      "mapel": "Bahasa Indonesia",
      "kelas": "7B",
      "bab": "Teks Eksposisi",
      "semester": "Genap",
      "tanggalStr": "12 Jan 2025",
      "tanggal": DateTime(2025, 1, 12),
      "status": "Menunggu Review",
    },
    {
      "mapel": "IPA",
      "kelas": "9A",
      "bab": "Sistem Pernafasan",
      "semester": "Ganjil",
      "tanggalStr": "5 Jan 2025",
      "tanggal": DateTime(2025, 1, 5),
      "status": "Disetujui",
    },
    {
      "mapel": "IPS",
      "kelas": "7A",
      "bab": "Interaksi Sosial",
      "semester": "Genap",
      "tanggalStr": "9 Jan 2025",
      "tanggal": DateTime(2025, 1, 9),
      "status": "Revisi",
    },
  ];

  List<Map<String, dynamic>> _filteredRpp = [];
  String searchQuery = "";
  String statusFilter = "Semua";

  String? sortColumn;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    _filteredRpp = [..._allRpp];
  }

  // ================= FILTER =================
  void _applyFilters() {
    final q = searchQuery.toLowerCase();

    setState(() {
      _filteredRpp = _allRpp.where((item) {
        final matchSearch =
            item["mapel"].toLowerCase().contains(q) ||
            item["kelas"].toLowerCase().contains(q) ||
            item["bab"].toLowerCase().contains(q);

        final matchStatus =
            statusFilter == "Semua" || item["status"] == statusFilter;

        return matchSearch && matchStatus;
      }).toList();

      _applySorting();
    });
  }

  // ================= SORT =================
  void _applySorting() {
    if (sortColumn == null) return;

    _filteredRpp.sort((a, b) {
      final A = a[sortColumn];
      final B = b[sortColumn];

      if (A is String) return sortAscending ? A.compareTo(B) : B.compareTo(A);
      if (A is DateTime) return sortAscending ? A.compareTo(B) : B.compareTo(A);
      return 0;
    });
  }

  void _onSort(String field) {
    setState(() {
      if (sortColumn == field) {
        sortAscending = !sortAscending;
      } else {
        sortColumn = field;
        sortAscending = true;
      }
      _applySorting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _buildCard(),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _header(),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                _searchFilterRow(),
                const SizedBox(height: 16),
                _buildTable(), // ⬅️ FULL WIDTH
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Text(
        "Daftar RPP Saya",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ================= SEARCH + FILTER =================
  Widget _searchFilterRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari mapel, kelas, atau bab...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (v) {
              searchQuery = v;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: statusFilter,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.filter_list),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: "Semua", child: Text("Semua")),
              DropdownMenuItem(value: "Draft", child: Text("Draft")),
              DropdownMenuItem(
                value: "Menunggu Review",
                child: Text("Menunggu Review"),
              ),
              DropdownMenuItem(value: "Revisi", child: Text("Revisi")),
              DropdownMenuItem(value: "Disetujui", child: Text("Disetujui")),
            ],
            onChanged: (v) {
              statusFilter = v!;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, "/rpp/create"),
            icon: const Icon(Icons.add),
            label: const Text("Buat RPP"),
          ),
        ),
      ],
    );
  }

  // ================= TABLE (FULL WIDTH) =================
  Widget _buildTable() {
    return DataTable(
      columnSpacing: 18,
      headingRowColor: MaterialStateProperty.all(AppColors.primary),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      sortAscending: sortAscending,
      sortColumnIndex: sortColumn == null ? null : _columnIndex(sortColumn!),
      columns: [
        DataColumn(label: _sortable("Mapel", "mapel")),
        DataColumn(label: _sortable("Kelas", "kelas")),
        const DataColumn(label: Text("Bab")),
        DataColumn(label: _sortable("Semester", "semester")),
        DataColumn(label: _sortable("Tanggal", "tanggal")),
        const DataColumn(label: Text("Status")),
        const DataColumn(label: Text("Aksi")),
      ],
      rows: _filteredRpp.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(item["mapel"])),
            DataCell(Text(item["kelas"])),
            DataCell(Text(item["bab"], maxLines: 2)),
            DataCell(Text(item["semester"])),
            DataCell(Text(item["tanggalStr"])),
            DataCell(_statusChip(item["status"])),
            DataCell(_actionMenu(item)),
          ],
        );
      }).toList(),
    );
  }

  Widget _sortable(String label, String field) {
    return InkWell(
      onTap: () => _onSort(field),
      child: Row(
        children: [
          Text(label),
          if (sortColumn == field)
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  int _columnIndex(String field) {
    const map = {"mapel": 0, "kelas": 1, "semester": 3, "tanggal": 4};
    return map[field]!;
  }

  // ================= STATUS =================
  Widget _statusChip(String status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  // ================= ACTION =================
  Widget _actionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == "edit") {
          Navigator.pushNamed(context, "/rpp/edit", arguments: item);
        } else if (v == "view") {
          Navigator.pushNamed(context, "/rpp/preview", arguments: item);
        } else if (v == "export") {
          exportRppToPdf(item);
        } else if (v == "history") {
          Navigator.pushNamed(context, "/rpp/history", arguments: item);
        }
      },
      itemBuilder: (_) => [
        _menu(Icons.edit, "Edit", "edit"),
        _menu(Icons.visibility, "Lihat", "view"),
        _menu(Icons.picture_as_pdf, "Export PDF", "export"),
        _menu(Icons.history, "Riwayat", "history"),
      ],
    );
  }

  PopupMenuItem<String> _menu(IconData icon, String label, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
