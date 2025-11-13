import 'package:flutter/material.dart';

/// 🎨 Fintech Galaxy Theme Mejorado
class AppTheme {
  static const Color primaryColor = Color(0xFF5B3FFF);
  static const Color secondaryColor = Color(0xFF2E4CFF);
  static const Color accentColor = Color(0xFFFFA726);
  static const Color successColor = Color(0xFF30E0A1);
  static const Color errorColor = Color(0xFFF54B7C);

  static const Color surfaceDark = Color(0xFF0A0A1F);
  static const Color surfaceLight = Color(0xFFF5F7FB);

  static const Color textPrimaryDark = Color(0xFFEDEDED);
  static const Color textSecondaryDark = Color(0xFF9BA2B8);
  static const Color textPrimaryLight = Color(0xFF1E1E28);
  static const Color textSecondaryLight = Color(0xFF6E6E7A);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E0F5F), Color(0xFF343BBF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: surfaceDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1A1B33),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryDark,
      error: errorColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryDark,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1F203C),
      shadowColor: primaryColor.withAlpha(102), // reemplazo de withOpacity(0.4)
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: accentColor, size: 22),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: surfaceLight,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: textPrimaryLight,
      error: errorColor,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryLight,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: secondaryColor.withAlpha(51), // reemplazo de withOpacity(0.2)
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: textPrimaryLight,
    ),
    iconTheme: const IconThemeData(color: primaryColor, size: 22),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
