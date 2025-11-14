import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:orbita/presentation/providers/splash/splash_controller.dart';
// import '../../../core/theme/app_theme.dart'; // Ya no se usa para el gradiente

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashControllerProvider, (previous, next) {
      next.when(
        data: (status) {
          if (status == AuthStatus.authenticated) {
            context.replace('/dashboard');
          } else {
            context.replace('/login');
          }
        },
        error: (error, stackTrace) {
          context.replace('/login');
        },
        loading: () {},
      );
    });

    final theme = Theme.of(context);

    return Scaffold(
      // 👈 CORRECCIÓN: Se quitó el Container con el gradiente.
      // El Scaffold ahora usará el 'scaffoldBackgroundColor' del AppTheme.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFoldingCube(
              // 👈 CORRECCIÓN: Color ajustado al tema
              color: theme.colorScheme.primary,
              size: 60,
            ),
            const SizedBox(height: 30),
            Text(
              'Iniciando Orbita...',
              style: theme.textTheme.headlineLarge?.copyWith(
                // 👈 CORRECCIÓN: Color ajustado al tema
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cargando sistema, por favor espera...',
              style: theme.textTheme.bodyMedium?.copyWith(
                // 👈 CORRECCIÓN: Color ajustado al tema
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}