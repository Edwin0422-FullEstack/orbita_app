// lib/data/datasources/api_auth_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orbita/core/providers/dio_provider.dart';
import 'package:orbita/core/providers/storage_provider.dart';
import 'package:orbita/data/datasources/auth_datasource.dart';
import 'package:orbita/data/models/user_model.dart';
import 'package:orbita/domain/enums/auth_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_auth_datasource_impl.g.dart'; // Corre el build_runner después

// --- ¡LA MAGIA DE RIVERPOD! ---
// 1. Creamos un provider que construye nuestra clase...
@riverpod
AuthDatasource apiAuthDatasource(ApiAuthDatasourceRef ref) {
  return ApiAuthDatasourceImpl(
    ref.watch(dioProvider),           // 2. Le inyectamos Dio
    ref.watch(secureStorageProvider), // 3. Le inyectamos el Storage
  );
}

// --- LA CLASE CONCRETA ---
class ApiAuthDatasourceImpl implements AuthDatasource {

  final Dio dio;
  final FlutterSecureStorage storage;

  ApiAuthDatasourceImpl(this.dio, this.storage);

  // Clave privada para guardar el token
  final String _tokenKey = 'orbita_token';

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      // Asumimos que la API responde con:
      // { "token": "...", "user": { "_id": ..., "email": ... } }
      final user = UserModel.fromJson(response.data['user']);
      final token = response.data['token'];

      // 1. Guardamos el token
      await storage.write(key: _tokenKey, value: token);

      // 2. Devolvemos el DTO del usuario
      return user;

    } on DioException catch (e) {
      // (Aquí deberíamos mapear errores, ej. 401 a "InvalidCredentials")
      rethrow;
    }
  }

  @override
  Future<AuthStatus> checkAuthStatus() async {
    final token = await storage.read(key: _tokenKey);

    if (token == null) {
      return AuthStatus.unauthenticated;
    }

    try {
      // Intentamos una ruta protegida. Si funciona, estamos 'autenticados'.
      // (En una API real, tendríamos un endpoint '/auth/check-status')
      await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AuthStatus.authenticated;

    } catch (e) {
      // Si el token expiró o es inválido, la API dará 401
      await storage.delete(key: _tokenKey); // Limpiamos el token malo
      return AuthStatus.unauthenticated;
    }
  }

  @override
  Future<void> logout() async {
    // Simplemente borramos el token
    await storage.delete(key: _tokenKey);
  }
}