import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../../core/services/admin_rpp_service.dart';
import '../layout/rpp_layout.dart';
import 'package:intl/intl.dart';

class AdminRppListPage extends StatefulWidget {
  const AdminRppListPage({super.key});

  @override
  State<AdminRppListPage> createState() => _AdminRppListPageState();
}

class _AdminRppListPageState extends State<AdminRppListPage> {
  List<Map<String, dynamic>> _allRpp = [];
  List<Map<String, dynamic>> filtered = [];
  bool _isLoading = true;

  String search = "";
  String filterStatus = "Semua";
  String filterGuru = "Semua";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final result = await AdminRppService.getAllRpp();

    if (result['success'] == true) {
      final rawData = result['data'] as List;
      _allRpp = rawData.map((item) {
        // Format tanggal
        String formattedDate = "N/A";
        try {
          final createdAt = item['created_at'];
          if (createdAt != null && createdAt.isNotEmpty) {
            final DateTime dt = DateTime.parse(createdAt);
            formattedDate = DateFormat('dd MMM yyyy').format(dt);
          }
        } catch (_) {}

        return {
          "rpp_id": item['RPP_ID'],
          "guru": item['Guru_Nama'] ?? 'N/A',
          "mapel": item['Nama_Mata_Pelajaran'] ?? 'N/A',
          "kelas": item['Kelas'] ?? 'N/A',
          "semester": item['Semester'] ?? 'N/A',
          "bab": item['Nama_Mata_Pelajaran'] ?? 'N/A',
          "tanggal": formattedDate,
          "status": item['Status'] ?? 'Draft',
        };
      }).toList();

      filtered = [..._allRpp];
    }

    setState(() => _isLoading = false);
  }

  void _applyFilters() {
    final q = search.toLowerCase();
    setState(() {
      filtered = _allRpp.where((item) {
        return (item["mapel"].toLowerCase().contains(q) ||
                item["kelas"].toLowerCase().contains(q) ||
                item["bab"].toLowerCase().contains(q)) &&
            (filterStatus == "Semua" || item["status"] == filterStatus) &&
            (filterGuru == "Semua" || item["guru"] == filterGuru);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "admin",
      selectedRoute: "/admin/rpp",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _card(),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _card() {
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
              children: [_filterBar(), const SizedBox(height: 20), _table()],
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
        ),
      ),
      child: const Text(
        "Manajemen RPP Guru",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ================= FILTER BAR =================
  Widget _filterBar() {
    final guruList = [
      "Semua",
      ..._allRpp.map((e) => e["guru"] as String).toSet(),
    ];

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
            value: filterGuru,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Guru",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: guruList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              filterGuru = v!;
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: filterStatus,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              "Semua",
              "Draft",
              "Menunggu Review",
              "Revisi",
              "Disetujui",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {
              filterStatus = v!;
              _applyFilters();
            },
          ),
        ),
      ],
    );
  }

  // ================= TABLE (FIXED) =================
  Widget _table() {
    return LayoutBuilder(
      builder: (context, c) {
        return SizedBox(
          width: c.maxWidth,
          child: DataTable(
            columnSpacing: 22,
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
              DataColumn(label: Text("Bab")),
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
                  DataCell(
                    SizedBox(
                      width: 220,
                      child: Text(
                        item["bab"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text(item["tanggal"])),
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

  // ================= STATUS =================
  Widget _statusChip(String status) {
    final Map<String, Color> colorMap = {
      "Draft": Colors.grey,
      "Menunggu Review": Colors.blue,
      "Revisi": Colors.orange,
      "Disetujui": Colors.green,
    };

    final c = colorMap[status] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c),
      ),
    );
  }

  // ================= ACTION =================
  Widget _actionMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == 'view') {
          Navigator.pushNamed(context, "/rpp/preview", arguments: item);
        } else {
          Navigator.pushNamed(context, "/rpp/history", arguments: item);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'view', child: Text("Lihat RPP")),
        PopupMenuItem(value: 'history', child: Text("Riwayat")),
      ],
    );
  }
}
