import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../config/theme/colors.dart';
import 'tambah_kegiatan.dart'; // ⬅️ PENTING

class CalendarSchoolPage extends StatefulWidget {
  const CalendarSchoolPage({super.key});

  @override
  State<CalendarSchoolPage> createState() => _CalendarSchoolPageState();
}

class _CalendarSchoolPageState extends State<CalendarSchoolPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime(2025, 1, 10): [
      {"judul": "Rapat Guru", "deskripsi": "Rapat koordinasi"},
      {"judul": "Persiapan Ujian", "deskripsi": "Briefing ujian"},
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: _mainCard(context),
          ),
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Kegiatan"),
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            barrierDismissible: false,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(24),
              child: const EventFormCard(),
            ),
          );

          if (result != null && _selectedDay != null) {
            setState(() {
              final key = DateTime(
                _selectedDay!.year,
                _selectedDay!.month,
                _selectedDay!.day,
              );
              _events.putIfAbsent(key, () => []);
              _events[key]!.add(result);
            });
          }
        },
      ),
    );
  }

  // ================= MAIN CARD =================
  Widget _mainCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _calendar(),
                const SizedBox(height: 24),
                _detailSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _cardHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.8)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            "Kalender Sekolah",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CALENDAR =================
  Widget _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: _getEventsForDay,

      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),

      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return const SizedBox();

          return Column(
            children: events.take(2).map((e) {
              if (e is! Map<String, dynamic>) return const SizedBox();

              final String title = (e['judul'] ?? '').toString();

              return Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85), // ⬅️ FIX 2
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ================= DETAIL =================
  Widget _detailSection() {
    if (_selectedDay == null) {
      return const Text("Pilih tanggal untuk melihat kegiatan");
    }

    final events = _getEventsForDay(_selectedDay!);
    if (events.isEmpty) {
      return const Text("Tidak ada kegiatan pada hari ini");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kegiatan ${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),

        ...events.map(
          (e) => Card(
            child: ListTile(
              leading: const Icon(Icons.event, color: AppColors.primary),
              title: Text(e['judul']),
              subtitle: Text(e['deskripsi'] ?? '-'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/calendar/event/detail",
                  arguments: e,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
