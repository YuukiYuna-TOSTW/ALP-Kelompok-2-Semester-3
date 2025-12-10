import 'package:flutter/material.dart';
import '../../features/homepage/pages/tambah_kegiatan.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: EventFormCard()),
      ),
    };
  }
}
