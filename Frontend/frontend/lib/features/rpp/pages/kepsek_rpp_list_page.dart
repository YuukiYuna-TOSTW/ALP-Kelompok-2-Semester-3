import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../layout/rpp_layout.dart';
import '../utils/rpp_exporter.dart';

class RppAllListPage extends StatefulWidget {
  const RppAllListPage({super.key});

  @override
  State<RppAllListPage> createState() => _RppAllListPageState();
}

class _RppAllListPageState extends State<RppAllListPage> {
  // ================= SAMPLE DATA =================
  final List<Map<String, dynamic>> _allRpp = [
    {
      "guru": "Bu Sinta",
      "mapel": "Matematika",
      "kelas": "8A",
      "semester": "Ganjil",
      "tanggal": "10 Jan 2025",
      "status": "Menunggu Review",
    },
    {
      "guru": "Pak Amir",
      "mapel": "IPA",
      "kelas": "9A",
      "semester": "Ganjil",
      "tanggal": "12 Jan 2025",
      "status": "Revisi",
    },
    {
      "guru": "Bu Ayu",
      "mapel": "Bahasa Indonesia",
      "kelas": "7B",
      "semester": "Genap",
      "tanggal": "9 Jan 2025",
      "status": "Disetujui",
    },
  ];

  List<Map<String, dynamic>> _filtered = [];

  String search = "";
  String fGuru = "Semua";
  String fMapel = "Semua";
  String fKelas = "Semua";
  String fStatus = "Semua";

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allRpp);
  }

  // =====================================================
  // FILTER FUNCTION
  // =====================================================
  void _applyFilters() {
    final q = search.toLowerCase();

    setState(() {
      _filtered = _allRpp.where((item) {
        final matchesSearch =
            item["guru"].toLowerCase().contains(q) ||
            item["mapel"].toLowerCase().contains(q) ||
            item["kelas"].toLowerCase().contains(q);

        final g = fGuru == "Semua" || item["guru"] == fGuru;
        final m = fMapel == "Semua" || item["mapel"] == fMapel;
        final k = fKelas == "Semua" || item["kelas"] == fKelas;
        final s = fStatus == "Semua" || item["status"] == fStatus;

        return matchesSearch && g && m && k && s;
      }).toList();
    });
  }

  // =====================================================
  // UI START
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "kepsek",
      selectedRoute: "/kepsek/rpp",
      content: _buildContent(),
    );
  }

  // =====================================================
  // MAIN CONTENT
  // =====================================================
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _searchAndExportBar(),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 20),
                  _buildTable(), // ❌ NO horizontal scroll
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // CARD HEADER
  // =====================================================
  Widget _cardHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.8)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Text(
        "Semua RPP Guru",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // =====================================================
  // SEARCH + EXPORT
  // =====================================================
  Widget _searchAndExportBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari guru, mapel, atau kelas...",
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
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => exportRppToPdf({"data": _filtered}),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // FILTERS
  // =====================================================
  Widget _buildFilters() {
    return Row(
      children: [
        _dropdown(
          "Guru",
          fGuru,
          ["Semua", ..._allRpp.map((e) => e["guru"]).toSet()],
          (v) {
            fGuru = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdown(
          "Mapel",
          fMapel,
          ["Semua", ..._allRpp.map((e) => e["mapel"]).toSet()],
          (v) {
            fMapel = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdown(
          "Kelas",
          fKelas,
          ["Semua", ..._allRpp.map((e) => e["kelas"]).toSet()],
          (v) {
            fKelas = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdown(
          "Status",
          fStatus,
          const ["Semua", "Draft", "Menunggu Review", "Revisi", "Disetujui"],
          (v) {
            fStatus = v!;
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _dropdown(
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: title),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // =====================================================
  // TABLE
  // =====================================================
  Widget _buildTable() {
    return DataTable(
      columnSpacing: 20,
      headingRowHeight: 48,
      dataRowHeight: 56,
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
        DataColumn(label: Center(child: Text("Aksi"))),
      ],
      rows: _filtered.map((item) {
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

  // =====================================================
  // STATUS CHIP (FIXED)
  // =====================================================
  Widget _statusChip(String status) {
    late Color bg;
    late Color text;

    switch (status) {
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
            textAlign: TextAlign.center,
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

  // =====================================================
  // ACTION MENU
  // =====================================================
  Widget _actionMenu(Map<String, dynamic> item) {
    return Center(
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (v) {
          if (v == 'view') {
            Navigator.pushNamed(context, "/rpp/preview", arguments: item);
          } else if (v == 'review') {
            Navigator.pushNamed(context, "/kepsek/rpp/review", arguments: item);
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
            value: 'review',
            child: Row(
              children: [
                Icon(Icons.edit_note, size: 18),
                SizedBox(width: 8),
                Text("Review"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
