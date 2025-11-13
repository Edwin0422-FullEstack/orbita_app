// lib/presentation/providers/login/login_controller.dart
import 'package:orbita/core/providers/repository_providers.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
// 1. 👇 IMPORTAR EL LOCK PROVIDER
import 'package:orbita/presentation/providers/app_lock/app_lock_provider.dart';
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
      final user = await authRepository.login(email, password);

      // Actualizamos la sesión
      ref.read(sessionProvider.notifier).setUser(user);

      // 2. 👇 ¡AQUÍ ESTÁ LA MAGIA!
      // Al hacer login manual, desbloqueamos la app automáticamente.
      ref.read(appLockProvider.notifier).unlock();

      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}