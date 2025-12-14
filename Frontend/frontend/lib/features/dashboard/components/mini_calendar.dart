import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class CalendarEvent {
  final DateTime date;
  final String title;

  CalendarEvent({required this.date, required this.title});
}

class MiniCalendar extends StatefulWidget {
  final List<CalendarEvent> events;

  const MiniCalendar({super.key, required this.events});

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _selectedDate = DateTime.now();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================
          // ⭐ HEADER (BULAN + TOMBOL NAVIGASI)
          // ======================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _prevMonth,
              ),
              Text(
                "${months[_currentMonth.month - 1]} ${_currentMonth.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ======================================
          // ⭐ HEADER NAMA HARI
          // ======================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              return Expanded(
                child: Center(
                  child: Text(
                    weekDays[i],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 6),

          // ======================================
          // ⭐ GRID KALENDER
          // ======================================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (_, index) {
              final int day = index + 1;

              final date = DateTime(
                _currentMonth.year,
                _currentMonth.month,
                day,
              );

              // Event check
              final bool hasEvent = widget.events.any(
                (e) =>
                    e.date.year == date.year &&
                    e.date.month == date.month &&
                    e.date.day == date.day,
              );

              // Hari ini
              final bool isToday = _isSameDate(date, DateTime.now());

              // Tanggal yang dipilih
              final bool isSelected = _isSameDate(date, _selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isToday
                        ? AppColors.primary
                        : isSelected
                        ? AppColors.primary.withOpacity(.25)
                        : hasEvent
                        ? AppColors.primary.withOpacity(.12)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : hasEvent
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isToday || isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isToday ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ======================================
          // ⭐ KEGIATAN SEKOLAH HARI INI / TERPILIH
          // ======================================
          const Text(
            "Kegiatan Hari Ini",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          _buildEventsList(_selectedDate),
        ],
      ),
    );
  }

  // ================================================================
  // Cetak list event untuk tanggal yang dipilih
  // ================================================================
  Widget _buildEventsList(DateTime date) {
    final todaysEvents = widget.events
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();

    if (todaysEvents.isEmpty) {
      return const Text(
        "Tidak ada kegiatan.",
        style: TextStyle(color: AppColors.textGrey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: todaysEvents.map((e) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "• ${e.title}",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper
  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final months = [
  "Januari",
  "Februari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember",
];

final weekDays = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
