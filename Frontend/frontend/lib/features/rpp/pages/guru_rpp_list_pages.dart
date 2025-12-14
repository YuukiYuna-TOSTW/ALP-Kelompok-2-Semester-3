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

  // FILTERING
  void _applyFilters() {
    setState(() {
      final q = searchQuery.toLowerCase();

      _filteredRpp = _allRpp.where((item) {
        final matchesSearch =
            item["mapel"].toLowerCase().contains(q) ||
            item["kelas"].toLowerCase().contains(q) ||
            item["bab"].toLowerCase().contains(q);

        final matchesStatus =
            statusFilter == "Semua" || item["status"] == statusFilter;

        return matchesSearch && matchesStatus;
      }).toList();

      _applySorting();
    });
  }

  // SORTING
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
          constraints: const BoxConstraints(maxWidth: 1100),
          child: _buildCard(),
        ),
      ),
    );
  }

  // CARD WRAPPER
  Widget _buildCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Text(
              "Daftar RPP Saya",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                _buildSearchFilterRow(),
                const SizedBox(height: 20),
                _buildTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TOP SEARCH + FILTER + BUTTON
  Widget _buildSearchFilterRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari berdasarkan mapel, kelas, atau bab...",
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

        const SizedBox(width: 16),

        SizedBox(
          width: 220, // ⬅️ kasih ruang aman
          child: DropdownButtonFormField<String>(
            value: statusFilter,
            isExpanded: true, // ⬅️ WAJIB
            decoration: InputDecoration(
              hintText: "Status RPP",
              prefixIcon: const Icon(Icons.filter_list),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
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

        const SizedBox(width: 16),

        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/rpp/create"),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Buat RPP Baru"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          ),
        ),
      ],
    );
  }

  // FIXED TABLE (NO CONSTRAINT ERRORS)
  Widget _buildTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(AppColors.primary),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              columnSpacing: 20,
              sortColumnIndex: sortColumn == null
                  ? null
                  : _columnIndex(sortColumn!),
              sortAscending: sortAscending,

              columns: [
                DataColumn(label: _col("Mapel", "mapel")),
                DataColumn(label: _col("Kelas", "kelas")),
                const DataColumn(label: Text("Bab/Materi")),
                DataColumn(label: _col("Semester", "semester")),
                DataColumn(label: _col("Tanggal", "tanggal")),
                const DataColumn(label: Text("Status")),
                const DataColumn(label: Text("Aksi")),
              ],

              rows: _filteredRpp.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item["mapel"])),
                    DataCell(Text(item["kelas"])),
                    DataCell(Text(item["bab"])),
                    DataCell(Text(item["semester"])),
                    DataCell(Text(item["tanggalStr"])),
                    DataCell(statusChip(item["status"])),
                    DataCell(_buildActionMenu(item)),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // SORTABLE COLUMN LABEL
  Widget _col(String label, String field) {
    return InkWell(
      onTap: () => _onSort(field),
      child: Row(
        children: [
          Text(label),
          if (sortColumn == field)
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: 14,
            ),
        ],
      ),
    );
  }

  int _columnIndex(String field) {
    const map = {"mapel": 0, "kelas": 1, "semester": 3, "tanggal": 4};
    return map[field]!;
  }

  // STATUS CHIP
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(10),
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

  // ACTION MENU
  Widget _buildActionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.primary),
      onSelected: (value) {
        switch (value) {
          case "edit":
            Navigator.pushNamed(context, "/rpp/edit", arguments: item);
            break;
          case "view":
            Navigator.pushNamed(context, "/rpp/preview", arguments: item);
            break;
          case "export":
            exportRppToPdf(item);
            break;
          case "history":
            Navigator.pushNamed(context, "/rpp/history", arguments: item);
            break;
        }
      },
      itemBuilder: (_) => [
        _popup(Icons.edit, "Edit", "edit"),
        _popup(Icons.visibility, "Lihat", "view"),
        _popup(Icons.picture_as_pdf, "Export PDF", "export"),
        _popup(Icons.history, "Riwayat", "history"),
      ],
    );
  }

  PopupMenuItem<String> _popup(IconData icon, String text, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(text)],
      ),
    );
  }
}
