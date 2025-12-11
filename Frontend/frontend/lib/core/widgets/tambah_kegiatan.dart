import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/config/theme/colors.dart'; // Import path yang benar

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

  String _formatDate(DateTime? d) {
    if (d == null) return 'D/M/Y';
    return '${d.day}/${d.month}/${d.year}';
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '00:00';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width > 600
        ? 620.0
        : MediaQuery.of(context).size.width * 0.95;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header dengan tombol silang
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tutup tombol diklik')),
                        );
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Judul
                      TextFormField(
                        controller: _judulCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Judul*',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Judul wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Penyelenggara full width
                      TextFormField(
                        controller: _penyelenggaraCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Penyelenggara*',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Date/time pickers row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mulai :',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () => _pickDateTime(
                                    isMulai: true,
                                    ctx: context,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          255,
                                          224,
                                          224,
                                          224,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(_formatDate(_mulaiDate)),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.access_time,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(_formatTime(_mulaiTime)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selesai :',
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () => _pickDateTime(
                                    isMulai: false,
                                    ctx: context,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _formatDate(_selesaiDate),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.access_time,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(_formatTime(_selesaiTime)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Deskripsi
                      TextFormField(
                        controller: _deskripsiCtrl,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi*',
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Deskripsi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // File picker kecil di kiri
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF75CFFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _pickedFileName.isEmpty
                                      ? 'Pilih File'
                                      : _pickedFileName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles();
                                    if (result != null &&
                                        result.files.isNotEmpty) {
                                      setState(() {
                                        _pickedFileName =
                                            result.files.first.name;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.attach_file,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Submit button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final data = {
                                'judul': _judulCtrl.text.trim(),
                                'penyelenggara': _penyelenggaraCtrl.text.trim(),
                                'mulai': _mulaiDate != null
                                    ? '${_formatDate(_mulaiDate)} ${_formatTime(_mulaiTime)}'
                                    : null,
                                'selesai': _selesaiDate != null
                                    ? '${_formatDate(_selesaiDate)} ${_formatTime(_selesaiTime)}'
                                    : null,
                                'deskripsi': _deskripsiCtrl.text.trim(),
                                'file': _pickedFileName,
                              };

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Simpan kegiatan'),
                                  content: Text(
                                    'Data siap disimpan:\n\n${data.toString()}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Simpan Kegiatan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
}
