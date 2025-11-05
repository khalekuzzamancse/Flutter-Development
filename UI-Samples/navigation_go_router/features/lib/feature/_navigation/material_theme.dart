import 'package:flutter/material.dart';

Widget materialTheme({required Widget content}) {
  return MaterialApp(
    theme: ThemeData(colorScheme: MaterialTheme.lightScheme(), useMaterial3: true),
    darkTheme: ThemeData(colorScheme: MaterialTheme.darkHighContrastScheme(), useMaterial3: true),
    themeMode: ThemeMode.light,
    home: Scaffold(body: SafeArea(child: content)),
    debugShowCheckedModeBanner: false,
  );
}

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4B662C),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFCCEDA4),
      onPrimaryContainer: Color(0xFF344E16),
      secondary: Color(0xFF6E5E0E),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFF9E287),
      onSecondaryContainer: Color(0xFF534600),
      tertiary: Color(0xFF685F12),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFF1E58A),
      onTertiaryContainer: Color(0xFF4F4800),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      background: Color(0xFFF9FAEF),
      onBackground: Color(0xFF1A1C16),
      surface: Color(0xFFF9FAEF),
      onSurface: Color(0xFF1A1C16),
      surfaceVariant: Color(0xFFE1E4D5),
      onSurfaceVariant: Color(0xFF44483D),
      outline: Color(0xFF75796C),
      outlineVariant: Color(0xFFC5C8BA),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F312A),
      inversePrimary: Color(0xFFB1D18A),
      surfaceDim: Color(0xFFD9DBD0),
      surfaceBright: Color(0xFFF9FAEF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF3F5E9),
      surfaceContainer: Color(0xFFEEEFE4),
      surfaceContainerHigh: Color(0xFFE8E9DE),
      surfaceContainerHighest: Color(0xFFE2E3D8),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFB1D18A),
      onPrimary: Color(0xFF1E3702),
      primaryContainer: Color(0xFF344E16),
      onPrimaryContainer: Color(0xFFCCEDA4),
      secondary: Color(0xFFDCC66E),
      onSecondary: Color(0xFF3A3000),
      secondaryContainer: Color(0xFF534600),
      onSecondaryContainer: Color(0xFFF9E287),
      tertiary: Color(0xFFD4C871),
      onTertiary: Color(0xFF363100),
      tertiaryContainer: Color(0xFF4F4800),
      onTertiaryContainer: Color(0xFFF1E58A),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF12140E),
      onBackground: Color(0xFFE2E3D8),
      surface: Color(0xFF12140E),
      onSurface: Color(0xFFE2E3D8),
      surfaceVariant: Color(0xFF44483D),
      onSurfaceVariant: Color(0xFFC5C8BA),
      outline: Color(0xFF8E9285),
      outlineVariant: Color(0xFF44483D),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE2E3D8),
      inversePrimary: Color(0xFF4B662C),
      surfaceDim: Color(0xFF12140E),
      surfaceBright: Color(0xFF373A33),
      surfaceContainerLowest: Color(0xFF0C0F09),
      surfaceContainerLow: Color(0xFF1A1C16),
      surfaceContainer: Color(0xFF1E201A),
      surfaceContainerHigh: Color(0xFF282B24),
      surfaceContainerHighest: Color(0xFF33362E),
    );
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFF9F8),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFFFBBA7),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFFFF9F8),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFECC1B6),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFFFAF6),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFDDCA91),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFFFF9F9),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFFFBAB1),
      onErrorContainer: Color(0xFF000000),
      surface: Color(0xFF1A110F),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFFFF9F8),
      outline: Color(0xFFDCC6C0),
      outlineVariant: Color(0xFFDCC6C0),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE2E3D8),
      inversePrimary: Color(0xFF743624),
      surfaceDim: Color(0xFF12140E),
      surfaceBright: Color(0xFF423734),
      surfaceContainerLowest: Color(0xFF140C0A),
      surfaceContainerLow: Color(0xFF231917),
      surfaceContainer: Color(0xFF271D1B),
      surfaceContainerHigh: Color(0xFF322825),
      surfaceContainerHighest: Color(0xFF3D322F),
    );
  }

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  static ThemeData light() {
    return theme(lightScheme());
  }

  static ThemeData dark() {
    return theme(darkScheme());
  }
}

void main() {
  runApp(
    materialTheme(
      content: Center(
        child: Text('Hello, Flutter!'),
      ),
    ),
  );
}
