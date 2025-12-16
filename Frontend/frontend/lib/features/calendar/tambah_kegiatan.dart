import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:frontend/config/theme/colors.dart';
import '../../../core/services/tambah_kegiatan_service.dart';

class EventFormCard extends StatefulWidget {
  const EventFormCard({Key? key}) : super(key: key);

  @override
  State<EventFormCard> createState() => _EventFormCardState();
}

class _EventFormCardState extends State<EventFormCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  final TextEditingController _tempatCtrl = TextEditingController(); // ✅ TAMBAH controller tempat

  DateTime? _mulaiDate;
  TimeOfDay? _mulaiTime;
  DateTime? _selesaiDate;
  TimeOfDay? _selesaiTime;

  String _pickedFileName = '';
  String? _pickedFilePath; // ✅ simpan path file
  Uint8List? _pickedFileBytes; // ✅ untuk Web

  List<Map<String, dynamic>> _penyelenggaraList = [];
  int? _selectedPenyelenggaraId;
  bool _loadingPenyelenggara = true;

  @override
  void initState() {
    super.initState();
    _loadPenyelenggara();
  }

  Future<void> _loadPenyelenggara() async {
    setState(() {
      _loadingPenyelenggara = true;
    });

    final data = await TambahKegiatanService.getPenyelenggara();
    print('🎯 Loaded penyelenggara count: ${data.length}');
    
    if (mounted) {
      setState(() {
        _penyelenggaraList = data;
        _loadingPenyelenggara = false;
        if (_penyelenggaraList.isNotEmpty) {
          _selectedPenyelenggaraId = _penyelenggaraList[0]['id'] as int;
          print('✅ Default selected: ${_penyelenggaraList[0]}');
        } else {
          print('⚠️ Penyelenggara list kosong!');
        }
      });
    }
  }

  void _retryLoadPenyelenggara() {
    _loadPenyelenggara();
  }

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
                      onPressed: () => Navigator.pop(context),
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

                      // ✅ TAMBAH: Input Tempat (sama seperti Judul)
                      TextFormField(
                        controller: _tempatCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Tempat*',
                          isDense: true,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Tempat wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // DROPDOWN PENYELENGGARA
                      _loadingPenyelenggara
                          ? const SizedBox(
                              height: 48,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _penyelenggaraList.isEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '❌ Gagal memuat penyelenggara. Periksa backend.',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: _retryLoadPenyelenggara,
                                        child: const Text(
                                          'Coba Lagi',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : DropdownButtonFormField<int>(
                                  value: _selectedPenyelenggaraId,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Penyelenggara*',
                                    isDense: true,
                                  ),
                                  items: _penyelenggaraList
                                      .map((e) {
                                        final nama = e['nama'] ?? '-';
                                        final id = e['id'];
                                        return DropdownMenuItem<int>(
                                          value: id,
                                          child: Text(nama),
                                        );
                                      })
                                      .toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      _selectedPenyelenggaraId = v;
                                      print('Selected: $v');
                                    });
                                  },
                                  validator: (v) => v == null
                                      ? 'Penyelenggara wajib dipilih'
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
                              final result = await FilePicker.platform.pickFiles(withData: kIsWeb);
                              if (result != null && result.files.isNotEmpty) {
                                final f = result.files.first;
                                setState(() {
                                  _pickedFileName = f.name;
                                  if (kIsWeb) {
                                    _pickedFileBytes = f.bytes;          // ✅ Web: bytes
                                    _pickedFilePath = null;
                                  } else {
                                    _pickedFilePath = f.path;            // ✅ non-Web: path
                                    _pickedFileBytes = null;
                                  }
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_mulaiDate == null || _mulaiTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Tanggal & waktu mulai wajib dipilih')),
                                );
                                return;
                              }
                              if (_selesaiDate == null || _selesaiTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Tanggal & waktu selesai wajib dipilih')),
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                    child: CircularProgressIndicator()),
                              );

                              // ✅ KIRIM data termasuk tempat
                              final res = await TambahKegiatanService.createSchedule(
                                namaKegiatan: _judulCtrl.text,
                                deskripsi: _deskripsiCtrl.text,
                                tanggalMulai: _mulaiDate!,
                                waktuMulai: '${_mulaiTime!.hour.toString().padLeft(2, '0')}:${_mulaiTime!.minute.toString().padLeft(2, '0')}',
                                tanggalSelesai: _selesaiDate!,
                                waktuSelesai: '${_selesaiTime!.hour.toString().padLeft(2, '0')}:${_selesaiTime!.minute.toString().padLeft(2, '0')}',
                                penyelenggaraId: _selectedPenyelenggaraId ?? 1,
                                tempat: _tempatCtrl.text,
                                lampiranPath: _pickedFilePath,        // ✅ non-Web
                                lampiranBytes: _pickedFileBytes,      // ✅ Web
                                lampiranName: _pickedFileName,
                              );

                              if (mounted) Navigator.of(context).pop();

                              if (res['success'] == true) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res['message'] ?? 'Kegiatan disimpan'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context, {
                                    'judul': _judulCtrl.text,
                                    'deskripsi': _deskripsiCtrl.text,
                                  });
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res['message'] ?? 'Gagal menyimpan'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
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
