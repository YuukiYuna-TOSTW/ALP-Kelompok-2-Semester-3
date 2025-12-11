import 'package:flutter/material.dart';
import '../../core/widgets/tambah_kegiatan.dart';
import '../../features/calendar/table_calender.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: EventFormCard()),
      ),
      '/calendar': (context) => const CalendarPage(),
    };
  }
}
