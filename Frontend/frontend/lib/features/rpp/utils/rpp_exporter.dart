import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> exportRppToPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ===================== HEADER =====================
            pw.Center(
              child: pw.Text(
                "RENCANA PELAKSANAAN PEMBELAJARAN (RPP)",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // ===================== METADATA =====================
            _row("Mata Pelajaran", data["mapel"]),
            _row("Kelas", data["kelas"]),
            _row("Bab / Materi", data["bab"]),
            _row("Semester", data["semester"]),
            pw.Divider(),

            // ===================== ISI RPP =====================
            _section("Kompetensi Dasar", data["kd"]),
            _section("Kompetensi Inti", data["ki"]),
            _section("Tujuan Pembelajaran", data["tujuan"]),

            pw.SizedBox(height: 10),

            // ===================== KEGIATAN PEMBELAJARAN =====================
            pw.Text(
              "Kegiatan Pembelajaran",
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),

            _subSection("Pendahuluan", data["pendahuluan"]),
            _subSection("Kegiatan Inti", data["inti"]),
            _subSection("Penutup", data["penutup"]),

            pw.Divider(),

            // ===================== BAGIAN SELANJUTNYA =====================
            _section("Materi Pembelajaran", data["materi"]),
            _section("Asesmen Pembelajaran", data["asesmen"]),
            _section("Metode Pembelajaran", data["metode"]),
            _section("Media Pembelajaran", data["media"]),
            _section("Sumber Belajar", data["sumber"]),

            pw.SizedBox(height: 10),

            // ===================== LAMPIRAN =====================
            pw.Text(
              "Lampiran",
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),

            if (data["lampiran"] != null && data["lampiran"].isNotEmpty)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  for (var file in data["lampiran"])
                    pw.Text("- $file", style: const pw.TextStyle(fontSize: 12)),
                ],
              )
            else
              pw.Text(
                "- Tidak ada lampiran",
                style: const pw.TextStyle(fontSize: 12),
              ),
          ],
        );
      },
    ),
  );

  // ====== SIMPAN PDF DI TEMP DIRECTORY ======
  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/rpp_export.pdf");

  await file.writeAsBytes(await pdf.save());

  print("PDF berhasil dibuat: ${file.path}");
}

//
// =====================================================
// =============== HELPER FUNCTIONS =====================
// =====================================================
//

pw.Widget _row(String label, String? value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 140,
          child: pw.Text(
            "$label:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value?.isNotEmpty == true ? value! : "-",
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _section(String title, String? content) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 8),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          content?.isNotEmpty == true ? content! : "-",
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

pw.Widget _subSection(String title, String? content) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "• $title",
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 12),
          child: pw.Text(
            content?.isNotEmpty == true ? content! : "-",
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    ),
  );
}
