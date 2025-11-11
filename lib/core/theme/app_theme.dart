// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {

  // 1. ¡AQUÍ ESTÁ LA MAGIA!
  // Cambiamos el azul por un verde esmeralda/jade moderno.
  // M3 derivará TODO desde aquí.
  static const Color _seedColor = Color(0xFF0D9488); // Tailwind 'emerald-600'

  // 2. Definición del Tema Claro (Light Mode)
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    // (Podemos añadir más personalización después)
  );

  // 3. Definición del Tema Oscuro (Dark Mode)
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}