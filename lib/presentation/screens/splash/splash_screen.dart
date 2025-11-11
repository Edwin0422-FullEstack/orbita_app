// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:orbita/presentation/providers/splash/splash_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 1. Escuchamos el provider para reaccionar.
    ref.listen(splashControllerProvider, (previous, next) {

      // 2. Usamos .when() para manejar TODOS los estados.
      //    Esto es mucho más limpio y seguro.
      next.when(
        // --- CASO 1: ÉXITO ---
        data: (status) {
          if (status == AuthStatus.authenticated) {
            context.replace('/home');
          } else {
            context.replace('/login');
          }
        },

        // --- CASO 2: ERROR ---
        error: (error, stackTrace) {
          // Si el chequeo de auth falla (sin red, etc.),
          // lo mandamos al login. No dejamos al usuario atascado.
          // (Aquí podríamos loggear el error a Sentry/Datadog)
          // print('Error en Splash: $error');
          context.replace('/login');
        },

        // --- CASO 3: CARGANDO ---
        loading: () {
          // El listener se dispara una vez en 'loading'.
          // No hacemos nada, porque ya estamos en la pantalla de carga.
          // Esperamos al siguiente estado (data o error).
        },
      );
    });

    // 3. La UI sigue siendo la misma: un simple estado de carga.
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 20),
            Text('Iniciando Orbita...'),
          ],
        ),
      ),
    );
  }
}