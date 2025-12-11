import 'package:flutter/material.dart';

class AppColors {
  // Background lembut (tetap)
  static const background = Color(0xFFFBFBFB);

  // Warna utama — dibuat sedikit lebih kontras (lebih gelap 8–12%)
  static const primary = Color(0xFF5AC3FF); // dari 75CFFF → lebih bold
  static const secondary = Color(0xFF3B9EE6); // dari 4DAFF5 → lebih kontras
  static const accent = Color(0xFF6FAEFE); // dari 7FB9FF → diperjelas

  // Card aesthetic — cardBlue dibuat sedikit lebih gelap untuk kontras
  static const cardLight = Color(0xFFF3F3F3);
  static const cardBlue = Color(0xFFB7D6EE); // dari C6E3F8 → lebih tegas

  // Text — dibuat lebih tegas
  static const textDark = Color(0xFF111111); // lebih kontras dari 1C1C1C
  static const textGrey = Color(0xFF4B5563); // lebih gelap dari 6B7280
}
