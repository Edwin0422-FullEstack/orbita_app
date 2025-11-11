// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbita/core/router/app_router.dart';
import 'package:orbita/core/theme/app_theme.dart';

void main() {
  // (Aquí irán inicializaciones futuras como Firebase, etc.)
  
  runApp(
    // 1. Inicializamos Riverpod
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // 2. Observamos el provider del router
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      // 3. Conectamos GoRouter
      routerConfig: router,
      
      // 4. Conectamos nuestros Temas M3
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // O un provider para cambiarlo

      debugShowCheckedModeBanner: false,
      title: 'Orbita',
    );
  }
}
