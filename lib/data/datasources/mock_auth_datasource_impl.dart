// lib/data/datasources/mock_auth_datasource_impl.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orbita/core/providers/storage_provider.dart';
import 'package:orbita/data/datasources/auth_datasource.dart';
import 'package:orbita/data/models/user_model.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_auth_datasource_impl.g.dart'; // Corre el build_runner después

// 1. Creamos un provider para este mock
@riverpod
AuthDatasource mockAuthDatasource(MockAuthDatasourceRef ref) {
  // Nota: Sigue usando el secureStorage real, pero para una clave 'mock'.
  return MockAuthDatasourceImpl(ref.watch(secureStorageProvider));
}

// 2. La implementación que "finge" todo
class MockAuthDatasourceImpl implements AuthDatasource {
  final FlutterSecureStorage storage;
  MockAuthDatasourceImpl(this.storage);

  // Usamos una clave de token diferente para no colisionar con la real
  final String _tokenKey = 'orbita_MOCK_token';

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulamos la demora de red
    await Future.delayed(const Duration(milliseconds: 800));

    // 3. ¡AQUÍ ESTÁ TU LÓGICA QUEMADA!
    if (email == 'eduin.abello7@gmail.com' && password == '123456') {

      // Guardamos un token falso
      await storage.write(key: _tokenKey, value: 'mock-fake-token-12345');

      // Devolvemos el DTO (UserModel) falso
      return const UserModel(
        id: 'mock-user-id',
        email: 'eduin.abello7@gmail.com',
        fullName: 'Edwin Abello (Mock)',
        token: 'mock-fake-token-12345',
        isVerified: false,
      );
    } else {
      // Si falla, lanzamos un error como si fuera la API
      throw Exception('Credenciales (mock) incorrectas');
    }
  }

  @override
  Future<AuthStatus> checkAuthStatus() async {
    // Simulamos demora
    await Future.delayed(const Duration(milliseconds: 300));

    final token = await storage.read(key: _tokenKey);

    if (token != null && token.startsWith('mock-')) {
      return AuthStatus.authenticated;
    }
    return AuthStatus.unauthenticated;
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: _tokenKey);
  }
}