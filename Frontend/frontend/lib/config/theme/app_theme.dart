import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // warna dasar halaman
    scaffoldBackgroundColor: AppColors.background,

    // font global
    fontFamily: GoogleFonts.montserrat().fontFamily,

    // skema warna utama
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      // background dihilangkan karena deprecated, diganti pakai scaffoldBackgroundColor
    ),

    // styling card
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // app bar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: AppColors.textDark,
    ),
  );
}
