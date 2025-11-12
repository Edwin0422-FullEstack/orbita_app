// lib/core/providers/repository_providers.dart
import 'package:orbita/data/datasources/mock_auth_datasource_impl.dart'; // <-- 1. IMPORTAMOS EL MOCK
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:orbita/domain/repositories/auth_repository.dart';
import 'package:orbita/data/repositories_impl/auth_repository_impl.dart';
import 'package:orbita/data/datasources/api_auth_datasource_impl.dart';
import 'package:orbita/data/datasources/auth_datasource.dart'; // <-- 2. Importamos el CONTRATO

part 'repository_providers.g.dart';

// ------------------------------------
// --- ¡EL INTERRUPTOR MAESTRO! ---
// ------------------------------------
// (En un proyecto 2026, esto vendría de variables de entorno)
const bool _useMockData = true;
// ------------------------------------


@riverpod
AuthRepository authRepository(Ref ref) {

  final AuthDatasource datasource;

  // 3. Decidimos qué implementación inyectar
if (_useMockData) {
    datasource = ref.watch(mockAuthDatasourceProvider); // <-- Inyecta el MOCK
  } else {
    datasource = ref.watch(apiAuthDatasourceProvider); // <-- Inyecta el REAL
  }

  // 4. El AuthRepositoryImpl ni se entera.
  //    Simplemente recibe *algo* que cumple el contrato.
  return AuthRepositoryImpl(datasource);
}