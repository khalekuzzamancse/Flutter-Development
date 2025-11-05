import 'package:flutter/material.dart';

import '_app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.primaryColor,
    primarySwatch: Colors.blue,
    colorScheme: const ColorScheme.light(
          secondary: Colors.orange, // Set the accent color here
        ),
    fontFamily: 'Roboto', // Change the default font family
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 5,
    ),
  );
}
