import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';

class RolePreviewPage extends StatelessWidget {
  const RolePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roleCtrl = context.watch<RoleController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Role Preview • SMPN 1 Bontonompo Selatan",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih Role Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: roleCtrl.role,
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                  DropdownMenuItem(value: "guru", child: Text("Guru")),
                  DropdownMenuItem(
                    value: "kepsek",
                    child: Text("Kepsek / Wakasek"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) roleCtrl.setRole(value);
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/dashboard"),
                  child: const Text("Tampilkan Dashboard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
