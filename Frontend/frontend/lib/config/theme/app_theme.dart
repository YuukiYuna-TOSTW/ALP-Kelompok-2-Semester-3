import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData getAppTheme() {
  return ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );
}
