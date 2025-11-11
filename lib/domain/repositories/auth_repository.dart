// lib/domain/repositories/auth_repository.dart
import 'package:orbita/domain/entities/user.dart';
import 'package:orbita/domain/enums/auth_status.dart';

// Esta es la "Abstracción" (la 'D' de SOLID)
abstract class AuthRepository {

  // El trabajo del Splash
  Future<AuthStatus> checkAuthStatus();

  // El trabajo del Login
  Future<User> login(String email, String password);

  // Agreguemos el logout de una vez
  Future<void> logout();

// (Aquí irían register, forgotPassword, etc.)
}