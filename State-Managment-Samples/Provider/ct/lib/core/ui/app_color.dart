import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {
  // static const Color primary = Color(0xFF1F5DA0);
  // static const Color headingText = Color(0xBF1D1D1D);
  // static const Color blueGray = Color(0x80E4E4E4);
  // static const Color messageAction = Color(0xFF777777);
  static const Color primary = Color(0xFF2E6BB2);        // richer, slightly brighter blue
  static const Color headingText = Color(0xFF2C2C2C);    // deeper and more readable dark tone
  static const Color blueGray = Color(0xFFE0E6ED);       // soft gray-blue background
  static const Color messageAction = Color(0xFF5C6F82);  // muted slate tone for subtle UI actions

  static const TextTheme typography = TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));

  static const AppBarTheme appBarTheme = AppBarTheme(
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
          fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  static ThemeData theme=ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  textTheme: AppColor.typography,
  appBarTheme: AppColor.appBarTheme,
  elevatedButtonTheme: AppColor.elevatedButtonTheme,
  );
}
