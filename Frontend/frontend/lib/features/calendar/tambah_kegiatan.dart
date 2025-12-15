import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/config/theme/colors.dart';

class EventFormCard extends StatefulWidget {
  const EventFormCard({Key? key}) : super(key: key);

  @override
  State<EventFormCard> createState() => _EventFormCardState();
}

class _EventFormCardState extends State<EventFormCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _penyelenggaraCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();

  DateTime? _mulaiDate;
  TimeOfDay? _mulaiTime;
  DateTime? _selesaiDate;
  TimeOfDay? _selesaiTime;

  String _pickedFileName = '';

  Future<void> _pickDateTime({
    required bool isMulai,
    required BuildContext ctx,
  }) async {
    final date = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      if (isMulai) {
        _mulaiDate = date;
        _mulaiTime = time;
      } else {
        _selesaiDate = date;
        _selesaiTime = time;
      }
    });
  }

  String _formatDate(DateTime? d) =>
      d == null ? 'D/M/Y' : '${d.day}/${d.month}/${d.year}';

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '00:00';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width > 600
        ? 620.0
        : MediaQuery.of(context).size.width * 0.95;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tambahkan kegiatan',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context), // ✅ FIX
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ================= FORM =================
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _judulCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Judul*',
                          isDense: true,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Judul wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _penyelenggaraCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Penyelenggara*',
                          isDense: true,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _dateTimeBox(
                              label: 'Mulai',
                              date: _mulaiDate,
                              time: _mulaiTime,
                              onTap: () =>
                                  _pickDateTime(isMulai: true, ctx: context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateTimeBox(
                              label: 'Selesai',
                              date: _selesaiDate,
                              time: _selesaiTime,
                              onTap: () =>
                                  _pickDateTime(isMulai: false, ctx: context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _deskripsiCtrl,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi*',
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Deskripsi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.attach_file, size: 18),
                            label: Text(
                              _pickedFileName.isEmpty
                                  ? 'Pilih File'
                                  : _pickedFileName,
                            ),
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles();
                              if (result != null && result.files.isNotEmpty) {
                                setState(() {
                                  _pickedFileName = result.files.first.name;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context); // optional auto close
                            }
                          },
                          child: const Text(
                            'Simpan Kegiatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateTimeBox({
    required String label,
    required DateTime? date,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label :', style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(child: Text(_formatDate(date))),
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(_formatTime(time)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
