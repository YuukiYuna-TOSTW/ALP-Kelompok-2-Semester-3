import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:kalender/kalender.dart';
=======
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../features/homepage/widgets/developer_item.dart';
import '../../features/homepage/widgets/contact_item.dart';
>>>>>>> a72c25488a760764e92fa40631f67b7447272df6

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contoh Kalender',
      home: Scaffold(
        appBar: AppBar(title: Text('Kalender Demo')),
        body: MyCalendar(),
      ),
    );
  }
}

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    // contoh: tambahkan satu event sekarang
    final now = DateTime.now();
    eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(Duration(hours: 1)),
        ),
        data: "Contoh Event",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration:
          MultiDayViewConfiguration.singleDay(), // bisa diubah ke week, month, etc
      header: CalendarHeader(),
      body: CalendarBody(),
      callbacks: CalendarCallbacks(
        onEventTapped: (event, renderBox) {
          // aksi saat event diketuk
          print("Tapped event: ${event.data}");
        },
        onEventCreated: (event) {
          eventsController.addEvent(event);
        },
      ),
    );
  }
}
