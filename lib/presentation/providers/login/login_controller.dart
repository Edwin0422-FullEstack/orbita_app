// lib/presentation/providers/login/login_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbita/core/providers/repository_providers.dart';
// 1. IMPORTAR EL NUEVO PROVIDER DE SESIÓN
import 'package:orbita/presentation/providers/session/session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);

      // 2. ¡EL CAMBIO CLAVE! Capturamos el 'User'
      final user = await authRepository.login(email, password);

      // 3. ¡ALIMENTAMOS LA SESIÓN GLOBAL!
      ref.read(sessionProvider.notifier).setUser(user);

      // Éxito
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}