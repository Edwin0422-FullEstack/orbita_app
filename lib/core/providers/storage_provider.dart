// lib/core/providers/storage_provider.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart'; // Corre el build_runner después

@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  // Simplemente retornamos la instancia
  return const FlutterSecureStorage();
}