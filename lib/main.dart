// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 necesario para controlar UI del sistema
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ soporte regional
import 'package:orbita/core/router/app_router.dart';
import 'package:orbita/core/theme/app_theme.dart';

Future<void> main() async {
  // 🧩 Inicialización base de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 🌎 Inicializa formato de fechas regional (es_CO)
  await initializeDateFormatting('es_CO', null);

  // 🚫 Oculta barras de navegación y estado (modo inmersivo)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // 🧠 Inicia Riverpod + App
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1️⃣ Observa el router global
    final router = ref.watch(goRouterProvider);

    // 2️⃣ Construye la app con Material 3 + rutas
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Orbita Finanzas',

      // 🌙 Soporte de tema claro/oscuro
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
