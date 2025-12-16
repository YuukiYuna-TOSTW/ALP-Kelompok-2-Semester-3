import 'package:flutter/material.dart';
import 'package:frontend/core/services/guru_rpp_review_service.dart';
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
  ];

  List<Map<String, dynamic>> filtered = [];
  String search = "";
  String filterStatus = "Semua";

  String? sortColumn;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    filtered = [..._allRpp];
    _loadFromService(); // ✅ muat data dari backend
  }

  Future<void> _loadFromService() async {
    // Nama User dari session/login jika ada, jika tidak biarkan null agar default Kelompok2Guru
    final res = await GuruRppListService.fetchMyRpps(
      namaUser: null, // biarkan null: default Kelompok2Guru
      status: null,   // boleh isi "Menunggu Review" dll jika ingin filter awal
    );
    if (res['success'] == true) {
      final List<Map<String, dynamic>> list = (res['data'] as List).cast<Map<String, dynamic>>();
      setState(() {
        _allRpp
          ..clear()
          ..addAll(list);
        filtered = [..._allRpp];
        _applySorting();
      });
    } else {
      // tetap pakai dummy jika gagal, tanpa mengubah tampilan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Gagal memuat RPP')),
        );
      }
    }
  }

  void _applyFilters() {
    final q = search.toLowerCase();

    setState(() {
      filtered = _allRpp.where((item) {
        return (item["mapel"].toLowerCase().contains(q) ||
                item["kelas"].toLowerCase().contains(q) ||
                item["bab"].toLowerCase().contains(q)) &&
            (filterStatus == "Semua" || item["status"] == filterStatus);
      }).toList();
      _applySorting();
    });
  }

  void _applySorting() {
    if (sortColumn == null) return;

    filtered.sort((a, b) {
      final A = a[sortColumn];
      final B = b[sortColumn];
      if (A is String) return sortAscending ? A.compareTo(B) : B.compareTo(A);
      if (A is DateTime) return sortAscending ? A.compareTo(B) : B.compareTo(A);
      return 0;
    });
  }

  void _onSort(String field) {
    setState(() {
      sortAscending = sortColumn == field ? !sortAscending : true;
      sortColumn = field;
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
          child: _card(context),
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _filterBar(context),
                const SizedBox(height: 20),
                _table(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.8)],
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
    );
  }

  Widget _filterBar(BuildContext context) {
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
              search = v;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: filterStatus,
            decoration: InputDecoration(
              labelText: "Status",
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
              filterStatus = v!;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/rpp/create"),
          icon: const Icon(Icons.add),
          label: const Text("Buat RPP"),
        ),
      ],
    );
  }

  Widget _table() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: DataTable(
            columnSpacing: 24,
            headingRowColor: MaterialStateProperty.all(AppColors.primary),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            sortAscending: sortAscending,
            sortColumnIndex: sortColumn == null
                ? null
                : _columnIndex(sortColumn!),
            columns: [
              DataColumn(label: _sortable("Mapel", "mapel")),
              DataColumn(label: _sortable("Kelas", "kelas")),
              const DataColumn(label: Text("Bab / Materi")),
              DataColumn(label: _sortable("Semester", "semester")),
              DataColumn(label: _sortable("Tanggal", "tanggal")),
              const DataColumn(label: Text("Status")),
              const DataColumn(label: Text("Aksi")),
            ],
            rows: filtered.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item["mapel"])),
                  DataCell(Text(item["kelas"])),
                  DataCell(
                    Text(
                      item["bab"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(Text(item["semester"])),
                  DataCell(Text(item["tanggalStr"])),
                  DataCell(_statusChip(item["status"])),
                  DataCell(_actionMenu(item)),
                ],
              );
            }).toList(),
          ),
        );
      },
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

  int _columnIndex(String field) =>
      {"mapel": 0, "kelas": 1, "semester": 3, "tanggal": 4}[field]!;

  Widget _statusChip(String status) {
    final color =
        {
          "Draft": Colors.grey,
          "Menunggu Review": Colors.blue,
          "Revisi": Colors.orange,
          "Disetujui": Colors.green,
        }[status] ??
        Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _actionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == "edit") {
          Navigator.pushNamed(context, "/rpp/edit", arguments: item);
        } else if (v == "view") {
          Navigator.pushNamed(context, "/rpp/preview", arguments: item);
        } else if (v == "export") {
          exportRppToPdf(item);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: "edit", child: Text("Edit")),
        PopupMenuItem(value: "view", child: Text("Lihat")),
        PopupMenuItem(value: "export", child: Text("Export PDF")),
      ],
    );
  }
}
