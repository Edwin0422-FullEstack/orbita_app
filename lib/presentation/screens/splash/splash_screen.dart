import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:orbita/presentation/providers/splash/splash_controller.dart';
import '../../../core/theme/app_theme.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitFoldingCube(
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 30),
              Text(
                'Iniciando Orbita...',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Cargando sistema, por favor espera...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
