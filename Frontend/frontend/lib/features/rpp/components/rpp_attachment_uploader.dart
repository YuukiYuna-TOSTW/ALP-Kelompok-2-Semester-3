import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../config/theme/colors.dart';

class RppAttachmentUploader extends StatelessWidget {
  final List<String> files;
  final Function(String fileName) onAddFile;
  final Function(int index) onRemove;

  const RppAttachmentUploader({
    super.key,
    required this.files,
    required this.onAddFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        // ============================
        // BUTTON UNTUK UPLOAD FILE
        // ============================
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null && result.files.isNotEmpty) {
              final String fileName = result.files.single.name;
              onAddFile(fileName);
            }
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Icon(Icons.add_circle, size: 34, color: AppColors.primary),
          ),
        ),

        // ============================
        // FILE PREVIEW CARDS
        // ============================
        ...files.asMap().entries.map((entry) {
          int index = entry.key;
          String name = entry.value;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Tooltip(
                    message: name,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),

              // DELETE BUTTON
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => onRemove(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade400,
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
