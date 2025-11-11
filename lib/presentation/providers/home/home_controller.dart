// lib/presentation/providers/home/home_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbita/core/providers/repository_providers.dart';
// 1. IMPORTAR EL NUEVO PROVIDER DE SESIÓN
import 'package:orbita/presentation/providers/session/session_provider.dart';
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
      // 2. Llama al repositorio (como antes)
      await ref.read(authRepositoryProvider).logout();

      // 3. ¡LIMPIAMOS LA SESIÓN GLOBAL!
      ref.read(sessionProvider.notifier).clearUser();

      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}