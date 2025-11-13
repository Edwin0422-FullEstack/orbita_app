// lib/presentation/providers/home/home_controller.dart
import 'package:orbita/core/providers/repository_providers.dart';
import 'package:orbita/presentation/providers/session/session_provider.dart';
// 1. 👇 IMPORTAR EL LOCK PROVIDER
import 'package:orbita/presentation/providers/app_lock/app_lock_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      // 1. Cerrar sesión en API / Mock
      await ref.read(authRepositoryProvider).logout();

      // 2. Limpiar la sesión local del usuario
      ref.read(sessionProvider.notifier).clearUser();

      // 3. 👇 RE-BLOQUEAR LA APP
      // Esto resetea el ciclo de seguridad. La próxima vez que se inicie,
      // o si intentan navegar atrás, la app pedirá autenticación.
      ref.read(appLockProvider.notifier).lock();

      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}