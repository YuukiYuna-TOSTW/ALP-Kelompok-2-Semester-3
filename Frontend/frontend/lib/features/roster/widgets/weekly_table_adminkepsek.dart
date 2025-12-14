import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class WeeklyTableAdmin extends StatelessWidget {
  const WeeklyTableAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(
        AppColors.primary.withOpacity(.9),
      ),
      headingTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      columns: const [
        DataColumn(label: Text("Kelas")),
        DataColumn(label: Text("Hari")),
        DataColumn(label: Text("Jam")),
        DataColumn(label: Text("Mapel")),
        DataColumn(label: Text("Guru")),
      ],
      rows: const [
        // ================= SENIN =================
        DataRow(
          cells: [
            DataCell(Text("7A")),
            DataCell(Text("Senin")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("Matematika")),
            DataCell(Text("Bu Sinta")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("8B")),
            DataCell(Text("Senin")),
            DataCell(Text("08:30 - 09:20")),
            DataCell(Text("Bahasa Indonesia")),
            DataCell(Text("Pak Andi")),
          ],
        ),

        // ================= SELASA =================
        DataRow(
          cells: [
            DataCell(Text("7B")),
            DataCell(Text("Selasa")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("IPA")),
            DataCell(Text("Bu Rina")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("9A")),
            DataCell(Text("Selasa")),
            DataCell(Text("09:10 - 10:00")),
            DataCell(Text("IPS")),
            DataCell(Text("Pak Budi")),
          ],
        ),

        // ================= RABU =================
        DataRow(
          cells: [
            DataCell(Text("9C")),
            DataCell(Text("Rabu")),
            DataCell(Text("10:00 - 11:30")),
            DataCell(Text("IPA")),
            DataCell(Text("Pak Amir")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("8A")),
            DataCell(Text("Rabu")),
            DataCell(Text("08:00 - 09:30")),
            DataCell(Text("Matematika")),
            DataCell(Text("Bu Sinta")),
          ],
        ),

        // ================= KAMIS =================
        DataRow(
          cells: [
            DataCell(Text("7C")),
            DataCell(Text("Kamis")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("PPKn")),
            DataCell(Text("Bu Lina")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("9B")),
            DataCell(Text("Kamis")),
            DataCell(Text("09:10 - 10:00")),
            DataCell(Text("Bahasa Inggris")),
            DataCell(Text("Pak John")),
          ],
        ),

        // ================= JUMAT =================
        DataRow(
          cells: [
            DataCell(Text("8C")),
            DataCell(Text("Jumat")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("Seni Budaya")),
            DataCell(Text("Bu Maya")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("7A")),
            DataCell(Text("Jumat")),
            DataCell(Text("08:30 - 09:20")),
            DataCell(Text("PJOK")),
            DataCell(Text("Pak Deni")),
          ],
        ),
      ],
    );
  }
}
