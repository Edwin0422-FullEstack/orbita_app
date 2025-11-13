import 'package:flutter/material.dart';

/// 🌌 Tema Fintech Galaxy para Orbita
/// Inspirado en tonos violeta, azul profundo y lavanda.
/// Soporta modo claro y oscuro, con gradientes y tipografía moderna.
class AppTheme {
  // 🎨 Paleta base — del diseño Fintech Premium
  static const Color _primaryColor = Color(0xFF5B3FFF); // Violeta eléctrico
  static const Color _secondaryColor = Color(0xFF3B2CFF); // Azul violeta
  static const Color _surfaceDark = Color(0xFF0B0B1E); // Fondo principal oscuro
  static const Color _lavender = Color(0xFF8A7CFF); // Textos suaves
  static const Color _textSecondary = Color(0xFFB0B3D6);
  static const Color _success = Color(0xFF30E0A1);
  static const Color _error = Color(0xFFF54B7C);

  // 🌈 Gradientes principales
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_primaryColor, _secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E0F5F), Color(0xFF343BBF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 🕶️ Tema Oscuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _surfaceDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColor,
      secondary: _secondaryColor,
      surface: Color(0xFF1E0F5F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _textSecondary,
      error: _error,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _textSecondary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF151740).withOpacity(0.9),
      shadowColor: _primaryColor.withOpacity(0.4),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: _lavender, size: 22),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  // ☀️ Tema Claro (para dashboards o administración)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
      error: _error,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: _primaryColor,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: _secondaryColor.withOpacity(0.2),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    iconTheme: const IconThemeData(color: _primaryColor, size: 22),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
