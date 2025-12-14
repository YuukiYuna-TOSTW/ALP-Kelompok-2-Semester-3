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
  // UI START (Menggunakan RppLayout)
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
  // MAIN CONTENT (❌ TANPA Expanded)
  // =====================================================
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pageHeader(),
          const SizedBox(height: 20),
          _searchAndExportBar(),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 20),

          // ================= TABLE CONTAINER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildTable(),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================
  Widget _pageHeader() {
    return const Text(
      "Semua RPP Guru",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  // =====================================================
  // SEARCH BAR + EXPORT BUTTON
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
                borderRadius: BorderRadius.circular(10),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
  // TABLE
  // =====================================================
  Widget _buildTable() {
    return DataTable(
      columnSpacing: 28,
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
        DataColumn(label: Text("Aksi")),
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
            DataCell(_actionButtons(item)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(8),
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
