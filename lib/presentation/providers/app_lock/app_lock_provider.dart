// lib/presentation/providers/app_lock/app_lock_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock_provider.g.dart';

// Mantenemos 'keepAlive: true' porque este estado debe sobrevivir
// toda la vida de la app (igual que la sesión).
@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {

  @override
  bool build() {
    // true = La app inicia bloqueada por seguridad
    // false = La app está desbloqueada
    return true;
  }

  // Método para desbloquear (cuando pone PIN o Huella correcta)
  void unlock() {
    state = false;
  }

  // Método para bloquear (cuando cierra sesión o minimiza por mucho tiempo)
  void lock() {
    state = true;
  }
}