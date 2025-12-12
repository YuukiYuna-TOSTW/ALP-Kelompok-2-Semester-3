import 'package:flutter/material.dart';

Future<void> showRppAiDialog(
  BuildContext context, {
  TextEditingController? controller,
}) async {
  final tempCtrl = TextEditingController();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Bantu Tulis dengan AI"),
      content: TextField(
        controller: tempCtrl,
        decoration: const InputDecoration(hintText: "Tuliskan instruksi…"),
        maxLines: 4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller != null) {
              controller.text =
                  "Hasil AI berdasarkan instruksi: ${tempCtrl.text}";
            }
            Navigator.pop(context);
          },
          child: const Text("Gunakan"),
        ),
      ],
    ),
  );
}
