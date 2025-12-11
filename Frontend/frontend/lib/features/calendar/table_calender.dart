import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// CalendarPage is a reusable widget. Import and use `CalendarPage()` in
// your app's routes or screens where needed (the project already has a
// top-level `main()` in `lib/main.dart`).

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showDetailPanel = false;

  Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  Map<DateTime, List<String>> _getEventsForMonth(DateTime month) {
    Map<DateTime, List<String>> monthEvents = {};
    _events.forEach((key, value) {
      if (key.year == month.year && key.month == month.month) {
        monthEvents[key] = value;
      }
    });
    return monthEvents;
  }

  @override
  Widget build(BuildContext context) {
    final monthEvents = _getEventsForMonth(_focusedDay);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: _showDetailPanel ? 2 : 1,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TableCalendar(
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    firstDay: DateTime.utc(2010, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _showDetailPanel = _getEventsForDay(
                          selectedDay,
                        ).isNotEmpty;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xFF4DAFF5),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF7FB9FF),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: const Color(0xFF4DAFF5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    eventLoader: _getEventsForDay,
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: monthEvents.isEmpty
                        ? const Center(
                            child: Text('Tidak ada kegiatan bulan ini'),
                          )
                        : ListView(
                            children: monthEvents.entries.map((entry) {
                              final date = entry.key;
                              final activities = entry.value;
                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${date.day}-${date.month}-${date.year} (${activities.length} kegiatan)',
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: activities
                                        .map((act) => Text('- $act'))
                                        .toList(),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),

          if (_showDetailPanel)
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // HEADER
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF75CFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Activities on ${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showDetailPanel = false;
                                _selectedDay = null;
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: _getEventsForDay(_selectedDay!).isEmpty
                          ? const Center(
                              child: Text('Tidak ada kegiatan hari ini'),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: _getEventsForDay(_selectedDay!).length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final activity = _getEventsForDay(
                                  _selectedDay!,
                                )[index];
                                return Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: Text(activity),

                                    trailing: const Text(
                                      'Detail → (Disabled)',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4DAFF5),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
