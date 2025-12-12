import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';

import '../layout/rpp_layout.dart';
import '../components/rpp_section_editor.dart';
import '../components/rpp_metadata_form.dart';
import '../components/rpp_ai_dialog.dart';

class RppCreatePage extends StatefulWidget {
  const RppCreatePage({super.key});

  @override
  State<RppCreatePage> createState() => _RppCreatePageState();
}

class _RppCreatePageState extends State<RppCreatePage> {
  // metadata controllers
  final mapelCtrl = TextEditingController();
  final kelasCtrl = TextEditingController();
  final babCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();

  // section controllers
  final kdCtrl = TextEditingController();
  final kiCtrl = TextEditingController();
  final tujuanCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RppLayout(
      role: "guru",
      selectedRoute: "/rpp",
      content: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Buat RPP Baru",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 20),

        // FORM METADATA
        Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: RppMetadataForm(
              mapelCtrl: mapelCtrl,
              kelasCtrl: kelasCtrl,
              babCtrl: babCtrl,
              semesterCtrl: semesterCtrl,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // SECTIONS
        RppSectionEditor(
          title: "Kompetensi Dasar",
          controller: kdCtrl,
          readOnly: false,
          onAiPressed: () => showRppAiDialog(context, controller: kdCtrl),
        ),

        const SizedBox(height: 8),

        RppSectionEditor(
          title: "Kompetensi Inti",
          controller: kiCtrl,
          readOnly: false,
          onAiPressed: () => showRppAiDialog(context, controller: kiCtrl),
        ),

        const SizedBox(height: 8),

        RppSectionEditor(
          title: "Tujuan Pembelajaran",
          controller: tujuanCtrl,
          readOnly: false,
          onAiPressed: () => showRppAiDialog(context, controller: tujuanCtrl),
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Integrasikan ke backend
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              child: const Text("Simpan RPP"),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                // TODO: Simpan sebagai draft
              },
              child: const Text("Simpan Draft"),
            ),
          ],
        ),
      ],
    );
  }
}
