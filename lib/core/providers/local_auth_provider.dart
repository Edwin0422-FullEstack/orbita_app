// lib/core/providers/local_auth_provider.dart
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_auth_provider.g.dart'; // Corre el build_runner después

@riverpod
LocalAuthentication localAuth(Ref ref) {
  return LocalAuthentication();
}