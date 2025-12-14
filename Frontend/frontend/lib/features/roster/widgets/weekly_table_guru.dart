import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

class WeeklyTableGuru extends StatelessWidget {
  const WeeklyTableGuru({super.key});

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
        DataColumn(label: Text("Hari")),
        DataColumn(label: Text("Jam")),
        DataColumn(label: Text("Kelas")),
      ],
      rows: const [
        DataRow(
          cells: [
            DataCell(Text("Senin")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("7A")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("Selasa")),
            DataCell(Text("08:00 - 09:30")),
            DataCell(Text("8B")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("Rabu")),
            DataCell(Text("09:10 - 10:00")),
            DataCell(Text("9A")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("Kamis")),
            DataCell(Text("10:00 - 11:30")),
            DataCell(Text("8A")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text("Jumat")),
            DataCell(Text("07:30 - 08:20")),
            DataCell(Text("7B")),
          ],
        ),
      ],
    );
  }
}
