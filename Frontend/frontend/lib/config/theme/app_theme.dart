import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'typography.dart';

class AppTheme {
  // =============================
  //  🔵 LIGHT THEME (No Dark Mode)
  // =============================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    // TEXT THEME – kecil & modern
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      headlineMedium: AppTypography.h1,
      headlineSmall: AppTypography.h2,
      titleLarge: AppTypography.h3,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.small,
    ),

    fontFamily: GoogleFonts.montserrat().fontFamily,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
    ),

    // 🔹 APP BAR
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textDark,
      centerTitle: false,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      elevation: 0,
    ),

    // 🔹 BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textDark,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    ),

    // 🔹 CARDS
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    // 🔹 INPUT FIELDS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary.withOpacity(.30)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
      ),
    ),

    // 🔹 ICON THEME – lebih kecil
    iconTheme: const IconThemeData(color: AppColors.primary, size: 18),
  );
}
