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

  List<Map<String, dynamic>> filtered = [];

  String search = "";
  String fGuru = "Semua";
  String fMapel = "Semua";
  String fKelas = "Semua";
  String fStatus = "Semua";

  @override
  void initState() {
    super.initState();
    filtered = [..._allRpp];
  }

  void _applyFilters() {
    final q = search.toLowerCase();
    setState(() {
      filtered = _allRpp.where((e) {
        return (e["guru"].toLowerCase().contains(q) ||
                e["mapel"].toLowerCase().contains(q) ||
                e["kelas"].toLowerCase().contains(q)) &&
            (fGuru == "Semua" || e["guru"] == fGuru) &&
            (fMapel == "Semua" || e["mapel"] == fMapel) &&
            (fKelas == "Semua" || e["kelas"] == fKelas) &&
            (fStatus == "Semua" || e["status"] == fStatus);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "kepsek",
      selectedRoute: "/kepsek/rpp",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _card(),
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
              children: [
                _searchExport(),
                const SizedBox(height: 14),
                _filters(),
                const SizedBox(height: 20),
                _table(),
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.8)],
        ),
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

  // ================= SEARCH + EXPORT =================
  Widget _searchExport() {
    return Row(
      children: [
        Expanded(
          flex: 4,
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
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => exportRppToPdf({"data": filtered}),
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

  // ================= FILTER =================
  Widget _filters() {
    return Row(
      children: [
        _filter("Guru", fGuru, [
          "Semua",
          ..._allRpp.map((e) => e["guru"]).toSet(),
        ]),
        const SizedBox(width: 12),
        _filter("Mapel", fMapel, [
          "Semua",
          ..._allRpp.map((e) => e["mapel"]).toSet(),
        ]),
        const SizedBox(width: 12),
        _filter("Kelas", fKelas, [
          "Semua",
          ..._allRpp.map((e) => e["kelas"]).toSet(),
        ]),
        const SizedBox(width: 12),
        _filter("Status", fStatus, const [
          "Semua",
          "Draft",
          "Menunggu Review",
          "Revisi",
          "Disetujui",
        ]),
      ],
    );
  }

  Widget _filter(String label, String value, List<String> items) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {
          setState(() {
            if (label == "Guru") fGuru = v!;
            if (label == "Mapel") fMapel = v!;
            if (label == "Kelas") fKelas = v!;
            if (label == "Status") fStatus = v!;
            _applyFilters();
          });
        },
      ),
    );
  }

  // ================= TABLE (SAMA DENGAN GURU) =================
  Widget _table() {
    return LayoutBuilder(
      builder: (context, c) {
        return SizedBox(
          width: c.maxWidth,
          child: DataTable(
            columnSpacing: 22,
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
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("Aksi")),
            ],
            rows: filtered.map((e) {
              return DataRow(
                cells: [
                  DataCell(Text(e["guru"])),
                  DataCell(Text(e["mapel"])),
                  DataCell(Text(e["kelas"])),
                  DataCell(Text(e["semester"])),
                  DataCell(Text(e["tanggal"])),
                  DataCell(_statusChip(e["status"])),
                  DataCell(_action(e)),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _statusChip(String s) {
    final c = s == "Disetujui"
        ? Colors.green
        : s == "Revisi"
        ? Colors.orange
        : s == "Menunggu Review"
        ? Colors.blue
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        s,
        style: TextStyle(color: c, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _action(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      itemBuilder: (_) => const [
        PopupMenuItem(value: "view", child: Text("Lihat RPP")),
        PopupMenuItem(value: "review", child: Text("Review")),
      ],
      onSelected: (v) {
        if (v == "view") {
          Navigator.pushNamed(context, "/rpp/preview", arguments: item);
        } else {
          Navigator.pushNamed(context, "/kepsek/rpp/review", arguments: item);
        }
      },
    );
  }
}
