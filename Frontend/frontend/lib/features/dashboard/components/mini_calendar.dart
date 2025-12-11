import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class CalendarEvent {
  final DateTime date;
  final String title;

  CalendarEvent({required this.date, required this.title});
}

class MiniCalendar extends StatefulWidget {
  final List<CalendarEvent> events;

  /// NEW → Callback ketika tanggal diklik
  final Function(DateTime) onDateSelected;

  const MiniCalendar({
    super.key,
    required this.events,
    required this.onDateSelected,
  });

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
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
    int daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          // =========================
          // HEADER (Bulan)
          // =========================
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
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // GRID KALENDER
          // =========================
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

              final dayEvents = widget.events
                  .where(
                    (e) =>
                        e.date.year == date.year &&
                        e.date.month == date.month &&
                        e.date.day == date.day,
                  )
                  .toList();

              final bool hasEvent = dayEvents.isNotEmpty;

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: hasEvent
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: Colors.grey.shade300),
                    color: hasEvent
                        ? AppColors.primary.withOpacity(.1)
                        : Colors.white,
                  ),
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: hasEvent ? AppColors.primary : AppColors.textDark,
                      fontWeight: hasEvent ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

final months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "Mei",
  "Jun",
  "Jul",
  "Agu",
  "Sep",
  "Okt",
  "Nov",
  "Des",
];
