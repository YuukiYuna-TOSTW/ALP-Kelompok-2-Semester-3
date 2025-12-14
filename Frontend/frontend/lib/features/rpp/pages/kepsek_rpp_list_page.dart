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
  // MAIN CONTENT → SATU CARD BESAR
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _searchAndExportBar(),
                  const SizedBox(height: 16),
                  _buildFilters(),
                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildTable(),
                  ),
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
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
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
        _dropdownFilter(
          title: "Guru",
          value: fGuru,
          items: ["Semua", ..._allRpp.map((e) => e["guru"]).toSet()],
          onChanged: (v) {
            fGuru = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdownFilter(
          title: "Mapel",
          value: fMapel,
          items: ["Semua", ..._allRpp.map((e) => e["mapel"]).toSet()],
          onChanged: (v) {
            fMapel = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdownFilter(
          title: "Kelas",
          value: fKelas,
          items: ["Semua", ..._allRpp.map((e) => e["kelas"]).toSet()],
          onChanged: (v) {
            fKelas = v!;
            _applyFilters();
          },
        ),
        const SizedBox(width: 16),
        _dropdownFilter(
          title: "Status",
          value: fStatus,
          items: const [
            "Semua",
            "Draft",
            "Menunggu Review",
            "Revisi",
            "Disetujui",
          ],
          onChanged: (v) {
            fStatus = v!;
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _dropdownFilter({
    required String title,
    required String value,
    required List items,
    required Function(String?) onChanged,
  }) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: title),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e.toString(),
                child: Text(e.toString()),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // =====================================================
  // TABLE (LEBAR KOLOM TERKONTROL)
  // =====================================================
  Widget _buildTable() {
    return DataTable(
      columnSpacing: 24,
      headingRowHeight: 50,
      dataRowHeight: 58,
      headingRowColor: WidgetStateProperty.all(AppColors.primary),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: SizedBox(width: 140, child: Text("Guru"))),
        DataColumn(label: SizedBox(width: 160, child: Text("Mapel"))),
        DataColumn(label: SizedBox(width: 90, child: Text("Kelas"))),
        DataColumn(label: SizedBox(width: 110, child: Text("Semester"))),
        DataColumn(label: SizedBox(width: 130, child: Text("Tanggal"))),
        DataColumn(label: SizedBox(width: 160, child: Text("Status"))),
        DataColumn(label: SizedBox(width: 110, child: Text("Aksi"))),
      ],
      rows: _filtered.map((item) {
        return DataRow(
          cells: [
            DataCell(SizedBox(width: 140, child: Text(item["guru"]))),
            DataCell(SizedBox(width: 160, child: Text(item["mapel"]))),
            DataCell(SizedBox(width: 90, child: Text(item["kelas"]))),
            DataCell(SizedBox(width: 110, child: Text(item["semester"]))),
            DataCell(SizedBox(width: 130, child: Text(item["tanggal"]))),
            DataCell(SizedBox(width: 160, child: _statusChip(item["status"]))),
            DataCell(SizedBox(width: 110, child: _actionButtons(item))),
          ],
        );
      }).toList(),
    );
  }

  // =====================================================
  // STATUS CHIP
  // =====================================================
  Widget _statusChip(String status) {
    Color color;
    switch (status) {
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  // =====================================================
  // ACTION BUTTONS
  // =====================================================
  Widget _actionButtons(Map<String, dynamic> item) {
    return Row(
      children: [
        IconButton(
          tooltip: "Lihat RPP",
          icon: const Icon(Icons.visibility, color: AppColors.primary),
          onPressed: () {
            Navigator.pushNamed(context, "/rpp/preview", arguments: item);
          },
        ),
        IconButton(
          tooltip: "Review RPP",
          icon: const Icon(Icons.edit_note, color: Colors.orange),
          onPressed: () {
            Navigator.pushNamed(context, "/kepsek/rpp/review", arguments: item);
          },
        ),
      ],
    );
  }
}
