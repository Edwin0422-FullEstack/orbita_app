// lib/data/repositories_impl/auth_repository_impl.dart
import 'package:orbita/data/datasources/auth_datasource.dart';
import 'package:orbita/data/models/user_model.dart'; // Importamos para el mapper .toEntity()
import 'package:orbita/domain/entities/user.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:orbita/domain/repositories/auth_repository.dart';

// 1. Implementamos el contrato del Dominio
class AuthRepositoryImpl implements AuthRepository {

  // 2. Dependemos de la ABSTRACCIÓN del Datasource (Inyección de Dependencias)
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<AuthStatus> checkAuthStatus() {
    // Para este, la lógica es un simple "pasamanos"
    return datasource.checkAuthStatus();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      // 3. Llamamos al datasource, que nos devuelve el DTO (UserModel)
      final userModel = await datasource.login(email, password);

      // 4. EL TRABAJO CLAVE: Mapeamos el DTO a Entidad
      return userModel.toEntity();

    } catch (e) {
      // (Aquí manejamos y transformamos errores de Dio a Errores de Dominio)
      // Por ahora, solo lo relanzamos.
      rethrow;
    }
  }

  @override
  Future<void> logout() {
    // Otro pasamanos
    return datasource.logout();
  }
}