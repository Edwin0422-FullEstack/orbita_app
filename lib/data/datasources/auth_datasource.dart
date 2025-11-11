// lib/data/datasources/auth_datasource.dart
import 'package:orbita/data/models/user_model.dart'; // Importamos el DTO
import 'package:orbita/domain/enums/auth_status.dart';

// Este es el contrato que define CÓMO obtenemos los datos crudos.
// Es muy similar al Repository, pero fíjate en la diferencia clave:
// Devuelve un UserModel (DTO), NO una User (Entidad).
abstract class AuthDatasource {

  Future<AuthStatus> checkAuthStatus();

  Future<UserModel> login(String email, String password);

  Future<void> logout();

// (Aquí irían register, forgotPassword, etc.)
}