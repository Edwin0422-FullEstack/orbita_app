// lib/core/providers/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart'; // Corre el build_runner después

@riverpod
Dio dio(DioRef ref) {
  final options = BaseOptions(
    // ⚠️ ¡IMPORTANTE! Esta es tu URL base de la API.
    // En un proyecto real, esto vendría de variables de entorno (flutter_dotenv)
    baseUrl: 'https://tu-api.orbita.com/api/v1',

    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  // (Aquí agregaríamos un Interceptor para inyectar el token
  // en todas las peticiones, pero eso lo hacemos después)

  return Dio(options);
}