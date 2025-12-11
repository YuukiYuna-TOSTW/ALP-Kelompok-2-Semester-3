import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  static final h1 = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static final h2 = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static final h3 = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static final body = GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static final small = GoogleFonts.montserrat(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );
}
