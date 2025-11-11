// lib/presentation/providers/session/session_provider.dart
import 'package:orbita/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart'; // Corre el build_runner después

// 1. Usamos 'keepAlive' para que este provider NUNCA muera
//    mientras la app esté viva. Es nuestro estado global.
@Riverpod(keepAlive: true)
class Session extends _$Session {

  // 2. El estado es simplemente la Entidad 'User', o nulo si no hay sesión.
  @override
  User? build() {
    return null; // Inicialmente no hay usuario
  }

  // 3. Método para "alimentar" el provider
  void setUser(User user) {
    state = user;
  }

  // 4. Método para limpiar al hacer logout
  void clearUser() {
    state = null;
  }

  // 5. Método para actualizar el estado de KYC
  //    (Lo usaremos cuando el usuario complete el flujo)
  void setUserVerified() {
    if (state != null) {
      state = state!.copyWith(isVerified: true);
    }
  }
}