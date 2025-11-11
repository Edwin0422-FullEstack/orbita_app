// lib/presentation/providers/splash/splash_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:orbita/core/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'splash_controller.g.dart';

@riverpod
// 1. EL CAMBIO: De 'SplashControllerRef' al 'Ref' genérico.
Future<AuthStatus> splashController(Ref ref) async { // <-- ¡Aquí está!

  // 2. Leemos el repositorio real.
  final authRepository = ref.read(authRepositoryProvider);

  // 3. Ejecutamos el chequeo real Y una espera mínima en paralelo
  final results = await Future.wait([
    authRepository.checkAuthStatus(),
    Future.delayed(const Duration(milliseconds: 1500)) // 1.5s Mínimo
  ]);

  // 4. Devolvemos el resultado real (el primero de la lista)
  final authStatus = results[0] as AuthStatus;

  return authStatus;
}