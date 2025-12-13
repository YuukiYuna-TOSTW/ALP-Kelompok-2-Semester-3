import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../rpp/layout/rpp_layout.dart';

class PengumumanDetailPage extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PengumumanDetailPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final ann = data ?? {};

    return RppLayout(
      role: "guru",
      selectedRoute: "/announcement",
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _buildCard(context, ann),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map ann) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item("Judul", ann["judul"]),
                _item("Dibuat Oleh", ann["oleh"]),
                _item("Target", ann["target"]),
                _item("Status", ann["status"]),
                _item("Tanggal Publikasi", ann["tanggal"]),
                const SizedBox(height: 20),

                _label("Isi Pengumuman"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ann["body"] ?? "Tidak ada isi.",
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 20),
                _label("Lampiran"),
                _attachments(context, ann["lampiran"]),

                const SizedBox(height: 30),
                _buttonBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Text(
            "Detail Pengumuman",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text("$title :")),
          Expanded(
            child: Text(
              value?.toString() ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
    );
  }

  Widget _attachments(BuildContext context, dynamic hasFile) {
    if (hasFile == true) {
      return Row(
        children: [
          const Icon(Icons.attach_file, color: AppColors.primary),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Mengunduh lampiran...")),
              );
            },
            child: const Text("Download File"),
          ),
        ],
      );
    }
    return const Text("Tidak ada lampiran.");
  }

  Widget _buttonBar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ditandai sebagai dibaca")),
          );
        },
        child: const Text("Tandai Sebagai Dibaca"),
      ),
    );
  }
}
