
import 'package:flutter/material.dart';
class Images{
  static const  _base='feature/auth/assets';
  static const logo='$_base/user.png';

}
class AppColor {
  static const Color primary = Color(0xFF00897B);        // deep teal — fresh and professional
  static const Color headingText = Color(0xFF2E2E2E);    // neutral dark for strong readability
  static const Color blueGray = Color(0xFFF1E9E2);       // warm light beige background tone
  static const Color messageAction = Color(0xFFD17B0F);  // amber accent for buttons or highlights

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